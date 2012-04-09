CALIFORNIUM_REVISION=e0378d4243db66994d373846c24687504e59a193
JAR_URL_PREFIX=http://cloud.github.com/downloads/errordeveloper/californium-jruby

deps: lib/cf.jar

lib:
	-@mkdir lib

lib/cf.jar: lib
	@curl $(JAR_URL_PREFIX)/cf-$(CALIFORNIUM_REVISION).jar > $@
