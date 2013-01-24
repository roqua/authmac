require 'authmac'

module Authmac
  describe Authenticator do
    let(:authenticator) { Authenticator.new("very secret key", "|", "sha1") }

    context 'for an empty hash' do
      let(:hash) { Hash.new }

      it 'succeeds with the correct hmac' do
        authenticator.validate(hash, "d9e74ca3b866d3f563180e9a478c4f9598f29414").should be_true
      end

      it 'fails with an incorrect hmac' do
        authenticator.validate(hash, "incorrect hmac").should be_false
      end
    end

    context 'for a hash with a single parameter' do
      it 'succeeds with the correct hmac' do
        authenticator.validate({single: 'parameter'}, hmacify("parameter")).should be_true
      end

      it 'fails with incorrect hmac' do
        authenticator.validate({single: 'parameter'}, 'wrong').should be_false
      end
    end

    context 'for a hash with multiple parameters' do
      it 'succeeds with correct hmac' do
        authenticator.validate({first: 'parameter', second: 'another'},
                               hmacify('parameter|another')).should be_true
      end

      it 'sorts hash values based on their keys' do
        authenticator.validate({second: 'another', first: 'parameter'},
                               hmacify('parameter|another')).should be_true

      end
    end

    def hmacify(string, method='sha1')
      digester = OpenSSL::Digest::Digest.new(method)
      OpenSSL::HMAC.hexdigest(digester, "very secret key", string)
    end
  end
end
