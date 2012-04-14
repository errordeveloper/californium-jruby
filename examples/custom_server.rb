require(File.join('lib', 'modules', 'basic_server'))

class Server < Cf::LocalAbstractEndpoint

  def initialize (port=7683, daemon=false)

    Cf::Log.init();
    # FIXME: cast the arguments to the right Java types
    @ep = Cf::LocalAbstractEndpoint.new #(port, daemon)

  end

  def handleRequest rq

    rq.respond(Cf::CodeRegistry::RESP_NOT_FOUND);
    rq.sendResponse();

  end

end

x = Server.new
