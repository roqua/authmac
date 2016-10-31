require 'openssl'

module Authmac
  class HmacChecker
    # @param message_format [symbol] `:values` or `:json`.
    #   `:json` will use a sorted json string to sign.
    #   `:values` will use the sorted values separated by `parameter_separator` to sign.
    def initialize(secret, message_format: :values,
                           parameter_separator: '|',
                           digest_function: 'sha1')
      @secret = secret
      @digest = digest_function
      @separator = parameter_separator
      @message_format = message_format
      fail Authmac::SecretError, 'secret too short, see rfc2104' unless @secret.bytes.size >= digester.digest_length * 2
    end

    def validate(hash, given_hmac)
      sign(hash) == given_hmac
    end

    def sign(hash)
      OpenSSL::HMAC.hexdigest(digester, @secret, message_string(hash))
    end

    def with_signature(hash, hmac_key = :hmac)
      hash.merge({hmac_key => sign(hash)})
    end

    private

    def digester
      OpenSSL::Digest.new(@digest)
    end

    def message_string(hash)
      fail ArgumentError, 'hash arg not a hash' unless hash.is_a? Hash

      case @message_format
      when :values
        hash_values_sorted_by_key(hash).flatten.join(@separator)
      when :json
        require 'json'
        JSON.generate(params_sorted_by_key(hash))
      else
        fail ArgumentError, 'unknown message_format'
      end
    end

    def hash_values_sorted_by_key(hash)
      hash.sort_by {|key, value| key }.map(&:last)
    end

    # stringifies and sorts hashes by key at all levels.
    def params_sorted_by_key(params)
      case params
      when Hash
        params.map     { |k, v| [k.to_s, params_sorted_by_key(v)] }
              .sort_by { |k, v| k }
              .to_h
      when Array
        params.map { |val| params_sorted_by_key(val) }
      else
        params
      end
    end
  end
end
