# HTTP Clients
The http clients defined here  use a generic interface so that other http client/libraries can be swapped out without
much change. Just use the same interfaces

### Want to use a different library?
Do you want use a different library like faraday or httparty? Just add the gem and implent a client that uses the same interfaces.

#### HTTP::RubyClient
This http client uses the standard http library that comes out of the box with ruby