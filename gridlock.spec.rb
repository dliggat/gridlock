#!/usr/bin/ruby

require 'gridlock.rb'

describe GridLock::Manager do
  it 'should set the service key and prompt for master password' do
    password = 'my_password'
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).exactly(2).and_return(password)
    obj.master_pass.should == password
  end

  it 'should raise on receiving an empty password' do
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).and_return('')
    lambda{obj.master_pass}.should raise_error(GridLock::PasswordLengthError)
  end

  it 'should raise on receiving a verification password that does not match' do
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).and_return('abc')
    obj.should_receive(:ask).and_return('def')
    lambda{obj.master_pass}.should raise_error(GridLock::PasswordMatchError)
  end
end

describe GridLock::TokenStream do
  it 'should have the correct letters set' do
    service = 'ymail.com'
    obj = GridLock::TokenStream.new('password', service)
    obj.class.letters[:cons].uniq.length.should == 20
    obj.class.letters[:vowels].uniq.length.should == 6
  end

  it 'should use SHA512 as the hash algorithm' do
    GridLock::TokenStream::HashAlg.should == 'sha512'
  end

  it 'should produce close to a uniform distribution of letters within cons and vowels' do
    service = 'ymail.com'
    obj = GridLock::TokenStream.new('password', service)
    h = Hash.new(0)
    100000.times do
      token = obj.yield_token
      token.each_char do |char|
        h[char] +=1
      end
    end
    puts h.inspect
  end
end

