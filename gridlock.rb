#!/usr/bin/ruby

require 'openssl'
require 'stringio'
require 'rubygems'
require 'highline/import'

module GridLock

  class PassphraseLengthError < StandardError; end
  class PassphraseMatchError < StandardError; end

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
    Sep = ' | '
    Letters = %W{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
    Columns = 13

    def initialize(service_key)
      @service_key = service_key
      @master = nil
    end

    def prompt
      @master = ask('Enter your master grid-passphrase: ') {|q| q.echo = '*'}
      if @master.nil? or @master.length == 0
        raise(PassphraseLengthError, 'The master grid-passphrase may not be the empty string.')
      end
      verify = ask('                          Confirm: ') {|q| q.echo = '*'}
      unless @master == verify
        raise(PassphraseMatchError, 'Passphrases do not match. Error.')
      end
    end

    def row_titles_array
      result = Array.new
      Letters.each {|letter| result << "-#{letter}#{letter}-"}
      result
    end

    def column_titles_array
      result = Array.new
      1.upto(Columns) {|i| result << "-%02d-" % i}
      result
    end
    
    def display
      puts generate_output
    end

    def master_pass
      if @master.nil?
        prompt
      end
      @master
    end
    
    private
    def generate_output
      s = StringIO.new
      token_stream = TokenStream.new(master_pass, @service_key)
      # Print the headers, starting with some whitespace and boxing.
      s.print ' ' * (TokenStream::TokenSize + Sep.length)
      s.puts column_titles_array.join(Sep)
      s.print ' ' * (TokenStream::TokenSize + Sep.length - 1)
      s.puts '-' * (TokenStream::TokenSize * Columns +
                    Sep.length * (Columns - 1) + 1)
      row_titles_array.each_with_index do |item, index|
        s.print '%s%s' % [item, Sep]
        row = Array.new
        column_titles_array.each do
          row << token_stream.yield_token
        end
        s.puts row.join(Sep)
      end
      s.string
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
