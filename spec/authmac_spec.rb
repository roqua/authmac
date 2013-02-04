require 'authmac'

module Authmac
  describe Authenticator do
    let(:hmac_checker)      { stub("HmacChecker", validate: true) }
    let(:timestamp_checker) { stub("TimestampChecker", validate: true) }
    let(:auth) { Authenticator.new(hmac_checker, timestamp_checker) }

    describe '#validate' do
      it 'checks hmac' do
        hash = {userid: 'someone', clientid: 'something'}
        hmac = "a-calculated-hmac"
        hmac_checker.should_receive(:validate).with(hash, hmac)
        auth.validate(hash.merge(hmac: hmac))
      end

      it 'raises HmacError if hmac is incorrect' do
        hmac_checker.stub(validate: false)
        auth.validate({}).hmac_failure?.should be_true
      end

      it 'checks timestamp' do
        timestamp = Time.now.to_i
        timestamp_checker.should_receive(:validate).with(timestamp)
        auth.validate({timestamp: timestamp.to_s})
      end

      it 'raises TimestampError if timestamp is out of bounds' do
        timestamp_checker.stub(validate: false)
        auth.validate({}).timestamp_failure?.should be_true
      end
    end

  end
end
