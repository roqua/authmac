require 'openssl'
require "authmac/version"

module Authmac
  class Authenticator
    def initialize(secret, digest_function = "sha1")
      @secret = secret
      @digest = digest_function
    end

    def validate(hash, given_hmac)
      calculate_hmac(hash) == given_hmac
    end

    private

    def digester
      OpenSSL::Digest::Digest.new(@digest)
    end

    def calculate_hmac(hash)
      OpenSSL::HMAC.hexdigest(digester, @secret, message_string(hash))
    end

    def message_string(hash)
      hash_values_sorted_by_key(hash).join('|')
    end

    def hash_values_sorted_by_key(hash)
      hash.sort_by {|key, value| key }.map(&:last)
    end
  end
end
