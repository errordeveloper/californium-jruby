require(File.join('lib', 'modules', 'basic_server'))
require(File.join('lib', 'modules', 'local_resources'))

class ExampleServer
  def initialize
    # Create the logger
    Cf::Log.init();
    # Create the endpoints container
    @ep = Cf::LocalEndpoint.new
    # Add a few basic endpoints
    @ep.addResource(Cf::HelloWorldResource.new)
    # This resource generates an errror if there
    # is no Internet connection
    #@ep.addResource(Cf::ZurichWeatherResource.new)

    # This is somewhat of a hack, but it works!
    # (see: `lib/modules/basic_resource`)

    @my = {};

    append = Proc.new { |with,handle,title,type|
      m = @my[handle] = with.new(handle)
      m.setTitle(title)
      m.setResourceType(type)
      @ep.addResource(m)
    }

    append.call(Text::Plain, 'hello.rb',
                'Hello, Californium + JRuby!', 'Test1')

    append.call(Application::JSON, 'hello.json',
                '{"kind_of": "JSON"}', 'Test2')

    # p @my

  end
end

x = ExampleServer.new
