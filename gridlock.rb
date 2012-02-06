#!/usr/bin/ruby

require 'openssl'
require 'rubygems'
require 'highline/import'
require 'colored'

module GridLock

  class MasterPasswordError < StandardError; end

  class TokenStream
    HashAlg = 'sha512'
    TokenSize = 4

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

    def initialize(master, service_key)
      @master = master
      @service_key = service_key
      @index = @master.length + @service_key.length
      @tokens = Array.new
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
        if intermediate.length == TokenSize
          @tokens << intermediate
          intermediate = ''
        end
      end
      @index += 1
    end
  end

  class Manager
    SmallGridSize = 13
    LargeGridSize = 26
    Sep = ' | '

    def initialize(service_key, large=true)
      @service_key = service_key
      @master = nil
      if large
        @grid_size = LargeGridSize
      else
        @grid_size = SmallGridSize
      end
    end

    def small?
      @grid_size == SmallGridSize
    end

    def prompt
      @master = ask('Enter the master password: ') {|q| q.echo = '*'}
      if @master.nil? or @master.length == 0
        raise(MasterPasswordError, 'Must choose a master password other than the empty string.')
      end
    end

    def border_array
      list = %W{a b c d e f g h i j k l m n o p q r s t u v w x y z}
      result = Array.new
      if small?
        list.each_slice(2) do |first,second|
          result << "-#{first.capitalize}#{second.capitalize}-"
        end
      else
        list.each do |letter|
          result << "-#{letter.capitalize}#{letter.capitalize}-"
        end
      end
      result
    end
    
    def display
      token_stream = TokenStream.new(master_pass, @service_key)
      border_items = border_array
      print ' ' * (TokenStream::TokenSize + Sep.length)
      puts border_items.join(Sep)
      odd = true
      border_items.each do |item|
        odd = ! odd
        print "#{item}#{Sep}"
        row = Array.new
        @grid_size.times { row << token_stream.yield_token }
        a = row.join(Sep)
        if odd
          puts a.yellow
        else
          puts a.green
        end
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
