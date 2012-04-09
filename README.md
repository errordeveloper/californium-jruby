# Californium/JRuby

This project attempts to bring Matthias Kovatsch's CoAP (Constrained
Application Protocol) Java framework to the Ruby (well, JRuby) community
to enable future ReSTfull applications using CoAP and hopefully combine
"the nice" Ruby language with so-well-known performance of JRuby!
Californium is in fact a very comprehensive framework and I wouldn't
bother having a ago at doing that in Ruby from scratch, so let's just
use what JRuby can do - bind to the Java API.

## Dependencies

If you wish to get the latest version of Californium, do this:

          git clone git://github.com/errordeveloper/californium-jruby.git && \
            cd californium-jruby && git submodule init && git submodule update

Then you will need to use Eclipse to build the JAR (_do let me know
if there is an easier way to do it without touching the IDE_), call
it `lib/cf.jar` and you should be good to go with basic examples!

Otherwise you can just do this:

          git clone git://github.com/errordeveloper/californium-jruby.git && \
            cd californium-jruby && make deps

It will download pre-built JAR and put it in the right place and you
can now run the examples.

## Work in progress

See `examples` directory for starters, I'll try to make it a proper
thing once I figured what it will be like.
