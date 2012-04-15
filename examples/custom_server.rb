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

x.router { |method,request|

  request.pretty_print
  as_json(request, {:a =>1, :b =>2, :c =>3})
  #error(request, :not_found)

}
