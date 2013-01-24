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
      hash, hmac = split_params(params)
      raise HmacError      unless @hmac_checker.validate(hash, hmac)
      raise TimestampError unless @timestamp_checker.validate(params[:timestamp])
      true
    end

    private

    def split_params(params)
      hash = params.dup
      hmac = hash.delete(:hmac)
      return [hash, hmac]
    end
  end
end
