require 'authmac'

module Authmac
  describe Authenticator do
    let(:hmac_checker)      { double("HmacChecker", validate: true) }
    let(:timestamp_checker) { double("TimestampChecker", validate: true) }
    let(:auth) { Authenticator.new(hmac_checker, timestamp_checker) }

    describe '#validate' do
      it 'checks hmac' do
        hash = {userid: 'someone', clientid: 'something'}
        hmac = "a-calculated-hmac"
        expect(hmac_checker).to receive(:validate).with(hash, hmac)
        auth.validate(hash.merge(hmac: hmac))
      end

      it 'raises HmacError if hmac is incorrect' do
        allow(hmac_checker).to receive(:validate).and_return(false)
        expect(auth.validate({}).hmac_failure?).to be_truthy
      end

      it 'checks timestamp' do
        timestamp = Time.now.to_i
        expect(timestamp_checker).to receive(:validate).with(timestamp)
        auth.validate({timestamp: timestamp.to_s})
      end

      it 'raises TimestampError if timestamp is out of bounds' do
        allow(timestamp_checker).to receive(:validate).and_return(false)
        expect(auth.validate({}).timestamp_failure?).to be_truthy
      end
    end

  end
end
