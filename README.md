TimeHash
========

https://rubygems.org/gems/time-hash

Just a normal Ruby Hash, with time (seconds) based expiration.
(It's pretty scary and makes Haskell programmers cry.)

API-wise, the only changes are that `[]=` is no longer used, and in it's place
you use `put`, which takes a key, value, and a time-to-live (seconds).

Also added: `expired?(key)` and `expire!` (explained below).

Usage:

~~~
gem install time-hash
~~~

~~~ruby
require 'time-hash'

th = TimeHash.new
th.put(:key, 1234, 10) # this will exist for 10 seconds
th.put(:key2, 12345, 0.2) # this will exist for 0.2 seconds
th # => { key: 1234, key2: 12345} }
 # after 0.2 seconds
th.has_key?(:key2) # => false
th # => { key: 1234 }
 # after 10 seconds
th # => {}

th[1] = 3 # this will raise an error. You must have a time! (use put)

~~~

This assumes that you want automatic expiration to occur. If not...

~~~ruby
require 'time-hash'

th = TimeHash.new(false)
th.put(:key, 1234, 0.001)
 # after 0.001 seconds
th # => { key: 1234 } # because it doesn't automatically expire
th.expire!
th # => {}
~~~

This means before *any* hash you must call `expire!` to remove out-of-date items.

About
-----

It just wraps a normal hash and keeps track of another hash, `times`, which is `key => [time added, ttl]`.
You can examine this read-only field using `th.times`.

Unfortunately this class adds O(n) to all operations (even simple ones) if you have automatic expiration on. But it's not too big of a deal, and if your hash gets big just manually expire things.



