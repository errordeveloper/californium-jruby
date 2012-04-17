## This example implements it's own kind of DSL
## and it might turn into a library one day ...

require(File.join('lib', 'modules', 'basic_server'))
require(File.join('lib', 'modules', 'registry'))

require(File.join('lib', 'classes', 'responder'))

## And the `addressable` implements RFC6570, that
## is kindda better then crafting it ourselves in
## Rails/Sinatra fashion!
require "addressable/uri"
require 'addressable/template'

module COAP
  class Server < Cf::LocalAbstractEndpoint

    include Addressable
    def initialize

      ## Initialize the Java logger
      Cf::Log.init

      ## Use our hack-ish `LocalAbstractEndpoint`
      @ep = Cf::LocalAbstractEndpoint.new

      ## This is the route handler procedure
      @route = Proc.new { |method, request, element|
        begin
          respond = COAP::Responder.new
          @mapper[method][request, element, respond]
        rescue NoMethodError
          request.respond(CR[:bad_request])
        end
      }

    end

   public
    ## Give it an RFC6570-formatted string and we
    ## will use that to parse the URIs to hashes
    def format(string)
      @pt = Template.new(string)
    end
    ## Set the route mapper, which is a hash of
    ## procedures, e.g.:
    ## `server.route ({ :get => proc {|rq,it,rs| p it }})`
    def router(mapper)
      @mapper = mapper
    end
    ## Customize the route handler (if you don't
    ## like the built-in one - I don't care!
    def custom=(&block)
      ## FIXME: validate number of arguments
      @route = Proc.new &block
    end

   private
    ## This is the method which takes the requests
    ## from the Californium stack, remember, we are
    ## on `LocalAbstractEndpoint` level
    def execute(request)
      request.pretty_print
      element = @pt.extract(URI.parse(request.get_uri_path))
      if element.nil? then
        request.respond(CR[:not_found])
      else
        primary(request, element)
      end
      request.send_response
      ## XXX: do we need to be able to really handle
      ## this method in a custom fashion?
    end
    ## Our primary router, I don't think anyone would
    ## need to override this one ...
    def primary(request, element)
      # TODO: see if it's faster to compare either
      # by `:java_class`, `:instance_of?` or `:code`
      case
      when request.instance_of?(Cf::GETRequest)
        @route.call(:get, request, element)
      when request.instance_of?(Cf::PUTRequest)
        @route.call(:put, request, element)
      when request.instance_of?(Cf::POSTRequest)
        @route.call(:post, request, element)
      when request.instance_of?(Cf::DELETERequest)
        @route.call(:delete, request, element)
      else
        request.respond(CR[:bad_request])
      end
    end
  end
end

## Usage example: `examples/custom_server.rb`
