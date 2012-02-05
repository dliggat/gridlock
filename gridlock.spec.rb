#!/usr/bin/ruby

require 'gridlock.rb'

describe GridLock do
  it 'should set the service key and prompt for master password' do
    password = 'my_password'
    obj = GridLock.new(key)
    obj.should_receive(:prompt).and_return(password)
    obj.master_pass.should == password
  end
end

