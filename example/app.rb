require 'sinatra'
require 'cgi'
require 'authmac'

set :app_file, __FILE__

get '/' do
  erb :form
end

post '/sign' do
  @checker = Authmac::HmacChecker.new("very_secret", 'sha256')
  @params_with_timestamp = params.merge('timestamp' => Time.now.to_i)
  @hmac    = @checker.sign(@params_with_timestamp)
  @params_with_hmac      = @params_with_timestamp.merge('hmac' => @hmac)
  @link                  = @params_with_hmac.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")

  erb :sign
end

get '/auth' do
  hmac_checker      = Authmac::HmacChecker.new("very_secret", 'sha256')
  timestamp_checker = Authmac::TimestampChecker.new(30, 10)
  authenticator     = Authmac::Authenticator.new(hmac_checker, timestamp_checker)
  @validation       = authenticator.validate(params)

  if @validation.success?
    erb :auth_success
  elsif @validation.hmac_failure?
    erb :auth_hmac_failure
  elsif @validation.timestamp_failure?
    erb :auth_timestamp_failure
  end
end