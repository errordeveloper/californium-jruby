require(File.join('lib', 'modules', 'basic_server'))

require 'json'

CR = { # TODO: put all of the code here and move to `code_registry.rb`
  :not_found                  =>Cf::CodeRegistry::RESP_NOT_FOUND,
  :deleted                    =>Cf::CodeRegistry::RESP_DELETED,
  :created                    =>Cf::CodeRegistry::RESP_CREATED,
  :bad_request                =>Cf::CodeRegistry::RESP_BAD_REQUEST,
  :bad_option                 =>Cf::CodeRegistry::RESP_BAD_OPTION,
  :bad_gatewat                =>Cf::CodeRegistry::RESP_BAD_GATEWAY,
  :forbidden                  =>Cf::CodeRegistry::RESP_FORBIDDEN,
  :unauthorized               =>Cf::CodeRegistry::RESP_UNAUTHORIZED,
  :precondition_faild         =>Cf::CodeRegistry::RESP_PRECONDITION_FAILED,
  :valid                      =>Cf::CodeRegistry::RESP_VALID,
  :changed                    =>Cf::CodeRegistry::RESP_CHANGED,
  :content                    =>Cf::CodeRegistry::RESP_CONTENT,
  :service_unavailable        =>Cf::CodeRegistry::RESP_SERVICE_UNAVAILABLE,
  :unsupported_media_type     =>Cf::CodeRegistry::RESP_UNSUPPORTED_MEDIA_TYPE,
  :internal_server_error      =>Cf::CodeRegistry::RESP_INTERNAL_SERVER_ERROR,
  :not_implemented            =>Cf::CodeRegistry::RESP_NOT_IMPLEMENTED,
  :not_acceptable             =>Cf::CodeRegistry::RESP_NOT_ACCEPTABLE,
}

class Server < Cf::LocalAbstractEndpoint

  def initialize #(port=5683, daemon=false)

    Cf::Log.init();
    # FIXME: cast the arguments to the right Java types
    @ep = Cf::LocalAbstractEndpoint.new #(port, daemon)

    # Intialize a dummy route procedure
    @route = Proc.new { |method,request| request.pretty_print }


  end

  def router &block
    @route = Proc.new &block
  end

  def execute(request)

    # TODO: see if it's faster to compare either
    # by `:java_class`, `:instance_of?` or `:code`
    case
    when request.instance_of?(Cf::GETRequest)
      @route.call(:get, request) 
    when request.instance_of?(Cf::PUTRequest)
      @route.call(:put, request)
    when request.instance_of?(Cf::POSTRequest)
      @route.call(:post, request)
    when request.instance_of?(Cf::DELETERequest)
      @route.call(:delete, request)
    else
      request.respond(CR[:bad_request])
    end
    request.send_response

  end

end

x = Server.new


def error(request,code)
  request.respond(CR[code])
end

def content(request,type,data)
  response = Cf::Response.new(CR[:content])
  response.set_payload(data)
  response.set_content_type(type)
  request.respond(response)
end

def as_json(request,hash)
  content(request, Cf::MediaTypeRegistry::APPLICATION_JSON, JSON(hash))
end

AppData = {}

def application(method, request)
  path = request.get_uri_path.split('/')

  response = Cf::Response.new(CR[:content])
  response.set_content_type(Cf::MediaTypeRegistry::APPLICATION_JSON)

  case path[1]
  when 'test'
    case method
    when :get
      response.set_payload(JSON({:test => request.get_uri_path}))
    when :put
      unless AppData.has_key?(request.get_uri_path) then
        AppData[request.get_uri_path] = 1
      else
        AppData[request.get_uri_path] += 1
      end
      p AppData
    end
  else
    response.set_payload(JSON({:result => 'error!'}))
  end
  return response
end

x.router { |method,request|

  static_routes = {
    '/test.json' => lambda { |method|
      case method
      when :get
        as_json(request, {:a =>1, :b =>2, :c =>3})
      else
        error(request, :bad_request)
      end
    }
  }

  request.pretty_print

  case request.get_uri_path.split('/')[1]
  when 'static'
    case route = static_routes[request.get_uri_path]
    when nil
      error(request, :not_found)
    else
      route.call(method)
    end
  else
    request.respond(application(method, request))
  end

}
