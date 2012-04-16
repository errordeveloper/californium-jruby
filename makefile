CDN_BASE_URL=http://cloud.github.com/downloads/errordeveloper/californium-jruby
CALIFORNIUM_REVISION=475cfd009d7f845d4de96eed2c54eb5a7a574d20
PROJECT_ROOT=whereis_makefile

JAR		?= jar
JAVA		?= java
JAVA_FLAGS	?= -server
JRUBYC		?= jrubyc
JRUBY		?= jruby
JRUBY_FLAGS	?= --server -I$(PROJECT_ROOT)
JRUBY_JAR	?= $(shell ruby -e "require 'rbconfig'; puts File.join(Config::CONFIG['libdir'], 'jruby.jar');")

CLASSPATH	:= ./:$(JRUBY_JAR)

EXAMPLES := $(wildcard examples/*.rb)
EXAMPLES_COMPILED := $(EXAMPLES:.rb=.class)
MODULES := $(wildcard lib/modules/*.rb)
MODULES_COMPILED := $(MODULES:.rb=.class)

COMPILED_CLASSES := $(MODULES_COMPILED) $(EXAMPLES_COMPILED)

.SUFFIXES: .class .rb .jar

.rb.class:
	jrubyc $<

examples: $(EXAMPLES_COMPILED)
modules: $(MODULES_COMPILED)


deps: lib/cf.jar

lib:
	-@mkdir lib

lib/cf.jar: lib
	@curl $(CDN_BASE_URL)/cf-$(CALIFORNIUM_REVISION).jar > $@

bundle.jar: $(COMPILED_CLASSES)
	jar cf $@ $^

clean:
	rm -f $(COMPILED_CLASSES)

flush_logs:
	find . -iname 'Californium-log.*' | xargs rm -f

server: bundle.jar
	java -cp $(CLASSPATH):./$< examples/server
