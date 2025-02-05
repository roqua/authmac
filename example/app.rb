require 'sinatra'
require 'cgi'
require 'authmac'
require 'json'

set :app_file, __FILE__
def hmac_secret
  "very_secret_string_of_at_least_the_length_of_the_hash_so_64_for_sha256"
end

get '/' do
  erb :form
end

post '/sign' do
  @params = params.select { |_k, v| v != '' }
  @secret = hmac_secret
  @checker = Authmac::HmacChecker.new(hmac_secret, parameter_separator: '|', digest_function: 'sha256')
  @params_to_sign = @params.merge \
    'timestamp'    => Time.now.to_i.to_s,
    'version'      => '3',
    'nonce'        => 'implementing_apps_should_store_this_to_prevent_replays',
    'consumer_key' => 'key_to_find_secret'
  @hmac    = @checker.sign(@params_to_sign)
  @params_with_hmac      = @params_to_sign.merge('hmac' => @hmac)
  @link                  = @params_with_hmac.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")

  erb :sign
end

get '/auth' do
  hmac_checker      = Authmac::HmacChecker.new(hmac_secret, parameter_separator: '|', digest_function: 'sha256')
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
