require 'openssl'

module Authmac
  class HmacChecker
    def initialize(secret, parameter_separator = '|', digest_function = 'sha1')
      @secret = secret
      @digest = digest_function
      @separator = parameter_separator
      fail Authmac::SecretError, 'secret too short, see rfc2104' unless @secret.bytes.size >= digester.digest_length * 2
    end

    def validate(hash, given_hmac)
      sign(hash) == given_hmac
    end

    def sign(hash)
      OpenSSL::HMAC.hexdigest(digester, @secret, message_string(hash))
    end

    private

    def digester
      OpenSSL::Digest.new(@digest)
    end

    def message_string(hash)
      hash_values_sorted_by_key(hash).join(@separator)
    end

    def hash_values_sorted_by_key(hash)
      hash.sort_by {|key, value| key }.map(&:last)
    end
  end
end

