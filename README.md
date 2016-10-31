# Authmac

[![Build Status](https://travis-ci.org/roqua/authmac.png)](https://travis-ci.org/roqua/authmac)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/roqua/authmac)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'authmac'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install authmac

## Usage

```
checker = Authmac::HmacChecker.new(secret, parameter_separator: '|', digest_function: 'sha1', message_format: :json)
checker.with_signature(params_to_send)
```

* message_format: :values or :json. Format of message-string to sign. default :values.
* digest_function: string to give `OpenSSL::Digest.new(digest_function)`
* parameter_separator: Used for :values format to separate values.

## Examples


```
params_to_sign = {
  'some_param' => 'foo',
  'other_param' => 'bar',
  'timestamp'    => timestamp.to_s, # 12345678
  'nonce'        => SecureRandom.urlsafe_base64(4), # ILFtHg
  'consumer_key' => 'my_key'
}
```

Classic syntax: signs values, sorted by key, joined by '|'

```
checker = Authmac::HmacChecker.new(ENV['consumer_secret'],
							       parameter_separator: '|',
							       digest_function: 'sha256')
params_to_send = checker.with_signature(params_to_sign)

checker.send(:message_string, params_to_sign) # "my_key|ILFtHg|bar|foo|123456789"
```

Syntax for more complex parameters, signs json, sorted by key (subhashes as well).

```
params_to_sign['some_param'] = {foo: [1, {bar: 2}]}
```

```
checker = Authmac::HmacChecker.new(ENV['consumer_secret'],
								   digest_function: 'sha256',
								   message_format: :json)
params_to_send = checker.with_signature(params_to_sign)

checker.send(:message_string, params_to_sign)
# '{"consumer_key":"my_key","nonce":"ILFtHg","other_params":"bar",' \
# '"some_param":{"foo":["1",{"bar":"2"}]},"timestamp":"12345678"}'

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
