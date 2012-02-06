#!/usr/bin/ruby

require 'openssl'
require 'rubygems'
require 'highline/import'

module GridLock

  class MasterPasswordError < StandardError; end

  class TokenStream
    HashAlg = 'sha512'

    @@letters = nil
    def self.letters
      if @@letters.nil?
        @@letters = {
          :cons => %W{b c d f g h j k l m n p q r s t v w x z},
          :vowels => %W{a e i o u y} 
        }
      end
      @@letters
    end

    def initialize(master, service_key, token_size=4)
      @master = master
      @service_key = service_key
      @index = @master.length + @service_key.length
      @tokens = Array.new
      @token_size = token_size
    end

    def yield_token
      if @tokens.length < 1
        populate_token_list
      end
      result = @tokens.first
      @tokens = @tokens[1..-1]
      result
    end
    
    private
    def populate_token_list
      d = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new(HashAlg), 
                               @master, 
                               @service_key + @index.to_s)
      odd = false
      intermediate = ''
      d.each_byte do |b|
        odd = ! odd
        if odd
          list = self.class.letters[:cons]
        else
          list = self.class.letters[:vowels]
        end
        intermediate << list[b % list.length]
        if intermediate.length == @token_size
          @tokens << intermediate
          intermediate = ''
        end
      end
      @index += 1
    end
  end

  class Manager
    def initialize(service_key)
      @service_key = service_key
      @master = nil
    end

    def prompt
      @master = ask('Enter the master password: ') {|q| q.echo = '*'}
      if @master.nil? or @master.length == 0
        raise(MasterPasswordError, 'Must choose a master password other than the empty string.')
      end
    end

    def self.border_array(grid_size)
      list = %W{a b c d e f g h i j k l m n o p q r s t u v w x y z}
      result = Array.new
      list.each do |letter|
        result << letter.capitalize * 4
        if result.length >= grid_size
          break
        end
      end
      result
    end
    
    Sep = ' | '
    def display
      grid = 13
      token_stream = TokenStream.new(master_pass, @service_key)
      border_items = self.class.border_array(grid)
      print '       '
      puts border_items.join(Sep)
      border_items.each do |item|
        print "#{item}#{Sep}"
        row = Array.new
        grid.times { row << token_stream.yield_token }
        a = row.join(Sep)
        puts a
      end
    end

    def master_pass
      if @master.nil?
        prompt
      end
      @master
    end
  end


  if __FILE__ == $0
    if ARGV.length < 1
      error = "
      Error. Usage:  `#{$0} $SERVICE_NAME_KEY`
               e.g:  `#{$0} ymail.com`
      "
      puts error
      Kernel.exit(1)
    end
    g = GridLock::Manager.new(ARGV[-1]).display
  end

end
