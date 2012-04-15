require(File.join('lib', 'modules', 'basic_server'))
require(File.join('lib', 'modules', 'registry'))

## We use `json-jruby` gem, it's apparently fast :)
require 'json'
## And the `addressable` implements RFC6570, that
## is kindda better then crafting it ourselves in
## Rails/Sinatra fashion!
require "addressable/uri"
require 'addressable/template'

class Server < Cf::LocalAbstractEndpoint

  include Addressable
  def initialize

    Cf::Log.init

    @ep = Cf::LocalAbstractEndpoint.new

  end

 public
  def parse(string)
    @pt = Template.new(string)
  end
  def route(&block)
    @route = Proc.new &block
  end

 private
  def execute(request)
    request.pretty_print
    element = @pt.extract(URI.parse(request.get_uri_path))
    if element.nil? then
      request.respond(CR[:not_found])
    else
      router(request, element)
    end
    request.send_response
  end
  def router(request, element)
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

x = Server.new

x.parse "/{section}/{subsection}/{item}"

response = Cf::Response.new(CR[:content])
response.set_content_type(MT[:json])


app = {
  :get => proc { |request,element|
    response.set_payload(element.to_json)
    request.respond(response)
  }
}

x.route { |method, request, element|
  if app[method].kind_of?(Proc)
    app[method].call(request, element)
  else
    request.respond(CR[:bad_request])
  end
}
