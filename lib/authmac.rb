require "authmac/version"
require 'authmac/hmac_checker'
require 'authmac/timestamp_checker'

module Authmac
  class SecretError < StandardError; end

  class ValidationResult
    def initialize(options = {})
      @hmac = options.fetch(:hmac)
      @timestamp = options.fetch(:timestamp)
    end

    def success?
      @hmac and @timestamp
    end

    def failure?
      !success?
    end

    def hmac_failure?
      !@hmac
    end

    def timestamp_failure?
      !@timestamp
    end
  end

  class Authenticator
    def initialize(hmac_checker, timestamp_checker)
      @hmac_checker = hmac_checker
      @timestamp_checker = timestamp_checker
    end

    def validate(params)
      ValidationResult.new(hmac:      validate_hmac(params),
                           timestamp: validate_timestamp(params))
    end

    private

    def validate_hmac(params)
      hash, hmac = split_params(params)
      @hmac_checker.validate(hash, hmac)
    end

    def validate_timestamp(params)
      timestamp = params[:timestamp].to_i
      @timestamp_checker.validate(timestamp)
    end

    def split_params(params)
      hash = params.reduce({}) { |memo, (k,v)| memo[k.to_sym] = v; memo }
      hmac = hash.delete(:hmac)
      return [hash, hmac]
    end
  end
end
