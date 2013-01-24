require 'authmac'

module Authmac
  describe Authenticator do
    let(:hmac_checker)      { stub(validate: true) }
    let(:timestamp_checker) { stub(validate: true) }
    let(:auth) { Authenticator.new(hmac_checker, timestamp_checker) }

    it 'checks hmac' do
      params = Hash.new(userid: 'someone', clientid: 'something')
      hmac   = "a-calculated-hmac"
      hmac_checker.should_receive(:validate).with(params, hmac)
      auth.validate(params.merge(hmac: hmac))
    end

    it 'checks timestamp' do
      timestamp = stub
      timestamp_checker.should_receive(:validate).with(timestamp)
      auth.validate({timestamp: timestamp})
    end

    it 'raises HmacError if hmac is incorrect' do
      hmac_checker.stub(validate: false)
      expect { auth.validate({}) }.to raise_error(HmacError)
    end

    it 'raises TimestampError if timestamp is out of bounds' do
      timestamp_checker.stub(validate: false)
      expect { auth.validate({}) }.to raise_error(TimestampError)
    end
  end
end
