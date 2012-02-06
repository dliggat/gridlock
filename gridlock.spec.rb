#!/usr/bin/ruby

require 'gridlock.rb'

describe GridLock::Manager do
  it 'should set the service key and prompt for master password' do
    password = 'my_password'
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).and_return(password)
    obj.master_pass.should == password
  end

  it 'should raise on receiving an empty password' do
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).and_return('')
    lambda{obj.master_pass}.should raise_error(GridLock::MasterPasswordError)
  end

end

describe GridLock::TokenStream do
  it 'should have the correct letters set' do
    service = 'ymail.com'
    obj = GridLock::TokenStream.new('password', 'ymail.com')
    obj.class.letters[:cons].uniq.length.should == 20
    obj.class.letters[:vowels].uniq.length.should == 6
  end

  it 'should foo' do
    obj = GridLock::TokenStream.new('password', 'ymail.com')
    obj.yield_token
    obj.yield_token
  end

  it 'should use SHA512 as the hash algorithm' do
    GridLock::TokenStream::HashAlg.should == 'sha512'
  end
end

