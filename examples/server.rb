if (File.dirname(__FILE__).split(':')[0] == 'jar') then
  require(File.join('lib', 'modules', 'basic_server'))
else
  require(File.join(File.dirname(__FILE__), '..', 'lib', 'modules', 'basic_server'))
end

class ExampleServer
  def initialize
    # Create the logger
    Cf::Log.init();
    # Create the endpoints container
    @ep = Cf::LocalEndpoint.new
    # Add a few basic endpoints
    @ep.addResource(Cf::HelloWorldResource.new)
    @ep.addResource(Cf::ZurichWeatherResource.new)
  end
end

x = ExampleServer.new
