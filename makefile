CDN_BASE_URL=http://cloud.github.com/downloads/errordeveloper/californium-jruby
CALIFORNIUM_REVISION=e0378d4243db66994d373846c24687504e59a193

JAR		?= jar
JAVA		?= java
JAVA_FLAGS	?= -server
JRUBYC		?= jrubyc
JRUBY		?= jruby
JRUBY_FLAGS	?= --server
JRUBY_JAR	?= $(shell ruby -e "require 'rbconfig'; puts File.join(Config::CONFIG['libdir'], 'jruby.jar');")

CLASSPATH	:= ./:./examples/:$(JRUBY_JAR)

EXAMPLES := $(wildcard examples/*.rb)
MODULES := $(wildcard lib/modules/*.rb)

.SUFFIXES: .class .rb .jar

.rb.class:
	jrubyc $<

examples: $(EXAMPLES:.rb=.class)
modules: $(MODULES:.rb=.class)


deps: lib/cf.jar

lib:
	-@mkdir lib

lib/cf.jar: lib
	@curl $(CDN_BASE_URL)/cf-$(CALIFORNIUM_REVISION).jar > $@

flush_logs:
	find . -iname 'Californium-log.*' | xargs rm -f

server: examples/server.class
	java -cp $(CLASSPATH) server
