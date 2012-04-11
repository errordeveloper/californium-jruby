require(File.join('..', 'lib', 'modules', 'basic_client'))

class ExampleClient
  def initialize
    # Create the logger
    Cf::Log.setLevel(Cf::Level::ALL);
    Cf::Log.init();
    req = Cf::GETRequest.new;
    req.setURI(Cf::URI.new('coap://localhost/'));
    req.setPayload(nil);
    req.prettyPrint();
    req.execute();
    sleep 10;
    res = Cf::Response.new;
    res.prettyPrint();
    # Create the endpoints container
    #@ep = Cf::LocalEndpoint.new
    # Add a few basic endpoints
  end
end

x = ExampleClient.new
