require "authmac/version"
require 'authmac/hmac_checker'

module Authmac
  class HmacError < StandardError; end
  class TimestampError < StandardError; end

  class Authenticator
    def initialize(hmac_checker, timestamp_checker)
      @hmac_checker = hmac_checker
      @timestamp_checker = timestamp_checker
    end

    def validate!(params)
      validate_hmac!(params)
      validate_timestamp!(params)
      true
    end

    def validate(params)
      validate!(params)
    rescue HmacError, TimestampError
      false
    end

    private

    def validate_hmac!(params)
      hash, hmac = split_params(params)
      raise HmacError unless @hmac_checker.validate(hash, hmac)
    end

    def validate_timestamp!(params)
      timestamp = params[:timestamp]
      raise TimestampError unless @timestamp_checker.validate(timestamp)
    end

    def split_params(params)
      hash = params.dup
      hmac = hash.delete(:hmac)
      return [hash, hmac]
    end
  end
end
