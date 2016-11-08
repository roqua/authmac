## Version 2.0.0 / 2016-11-08

* BREAKING: keyword arguments for HmacChecker.new
* Allow nested hashes/arrays to be signed.
* Add :json message_format to sign a sorted json string, instead of just values.

## Version 1.0.4 / 2014-06-20

* Added HmacChecker#with_signature which returns the given hash with the HMAC merged in.

## Version 1.0.3 / 2014-05-12

* Raise error when insecure key is being used, assuming all keys are hex values (see rfc2104)
* Only compatible with ruby 2
