#!/usr/bin/ruby

require 'openssl'
require 'rubygems'
require 'highline/import'

class GridLock

  def initialize(service_key)
    @service_key = service_key
  end

  def prompt
    @master = ask('Enter the master password: ') {|q| q.echo = '*'}
    if @master.nil? or @master.length == 0
      puts 'BOOOOOOOOOOOO'
    end
    puts "The password is #{@master}"
  end

  def display
    puts 'display'
  end

  def master_pass
    @master ||= prompt
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
  g = GridLock.new(ARGV[1])
  puts g.master_pass
end
