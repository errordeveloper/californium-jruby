require(File.join('lib', 'modules', 'basic_server'))
require(File.join('lib', 'modules', 'response', 'resources'))

class ExampleServer
  def initialize
    # Create the logger
    Cf::Log.init();
    # Create the endpoints container
    @ep = Cf::LocalEndpoint.new
    # Add a few basic endpoints
    @ep.addResource(Cf::HelloWorldResource.new)
    @ep.addResource(Cf::ZurichWeatherResource.new)

    # This is somewhat of a hack, but it works!
    # (see: `lib/modules/basic_resource`)
    @my = Text::Plain.new('helloWorld.rb')
    @my.setTitle('Hello Californium/JRuby!')
    @my.setResourceType('HelloWorldDisplayer')
    @ep.addResource(@my)

    @json = Application::JSON.new('test.json')
    @json.setTitle('{"hello":"json"}')
    @json.setResourceType('testJSON')
    @ep.addResource(@json)

  end
end

x = ExampleServer.new
