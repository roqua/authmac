require 'authmac/hmac_checker'

module Authmac
  describe HmacChecker do
    let(:checker) { HmacChecker.new('very secret random key of sufficient size', '|', 'sha1') }

    describe '#validate' do
      it 'raises an error for a secret shorter than the hmac output' do
        checker = HmacChecker.new('way too short key', '|', 'sha1')
        expect { checker.validate({}, '') }.to raise_error SecretError, 'secret too short, see rfc2104'
      end

      context 'for an empty hash' do
        let(:hash) { Hash.new }

        it 'succeeds with the correct hmac' do
          expect(checker.validate(hash, hmacify(''))).to be_truthy
        end

        it 'fails with an incorrect hmac' do
          expect(checker.validate(hash, 'wrong')).to be_falsey
        end
      end

      context 'for a hash with a single parameter' do
        it 'succeeds with the correct hmac' do
          expect(checker.validate({single: 'parameter'}, hmacify('parameter'))).to be_truthy
        end

        it 'fails with incorrect hmac' do
          expect(checker.validate({single: 'parameter'}, 'wrong')).to be_falsey
        end
      end

      context 'for a hash with multiple parameters' do
        it 'succeeds with correct hmac' do
          expect(checker.validate({first: 'parameter', second: 'another'},
                                  hmacify('parameter|another'))).to be_truthy
        end

        it 'sorts hash values based on their keys' do
          expect(checker.validate({second: 'another', first: 'parameter'},
                                  hmacify('parameter|another'))).to be_truthy
        end
      end
    end

    describe '#calculate_hmac' do
      it 'generates hmac' do
        expect(checker.sign(second: 'another', first: 'parameter')).to eq(hmacify('parameter|another'))
      end
    end

    def hmacify(string, method='sha1')
      digester = OpenSSL::Digest.new(method)
      OpenSSL::HMAC.hexdigest(digester, 'very secret random key of sufficient size', string)
    end
  end
end
