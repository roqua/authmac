require 'authmac/hmac_checker'

module Authmac
  describe HmacChecker do
    let(:checker) { HmacChecker.new("very secret key", "|", "sha1") }

    context 'for an empty hash' do
      let(:hash) { Hash.new }

      it 'succeeds with the correct hmac' do
        checker.validate(hash, hmacify('')).should be_true
      end

      it 'fails with an incorrect hmac' do
        checker.validate(hash, "wrong").should be_false
      end
    end

    context 'for a hash with a single parameter' do
      it 'succeeds with the correct hmac' do
        checker.validate({single: 'parameter'}, hmacify("parameter")).should be_true
      end

      it 'fails with incorrect hmac' do
        checker.validate({single: 'parameter'}, 'wrong').should be_false
      end
    end

    context 'for a hash with multiple parameters' do
      it 'succeeds with correct hmac' do
        checker.validate({first: 'parameter', second: 'another'},
                         hmacify('parameter|another')).should be_true
      end

      it 'sorts hash values based on their keys' do
        checker.validate({second: 'another', first: 'parameter'},
                         hmacify('parameter|another')).should be_true

      end
    end

    def hmacify(string, method='sha1')
      digester = OpenSSL::Digest::Digest.new(method)
      OpenSSL::HMAC.hexdigest(digester, "very secret key", string)
    end
  end
end
