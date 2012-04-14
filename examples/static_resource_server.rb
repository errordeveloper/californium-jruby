require(File.join('lib', 'modules', 'basic_server'))
require(File.join('lib', 'modules', 'local_resources'))

class ExampleServer
  include LocalResources
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

    # We also have a nicer nickname you can use:
    append.call(LocalApp::JSON, 'nickname.json',
                '{"kind_of": "JSON"}', 'Test2')

    begin
      require 'json'

      append.call(LocalApp::JSON, 'proper.json',
                  JSON({ :a => 1, :b => 2}),
                  'TestJSON')

      appendJSON = Proc.new { |handle,hash|
        append.call(LocalApp::JSON, handle, JSON(hash), 'MyJSON')
      }

      appendJSON.call('another.json', { :x => 'I do not know who is Jason P.' })

    rescue LoadError
      puts 'If you want to use JSON, run `gem install json-jruby`!'
    end


    # p @my

  end
end

x = ExampleServer.new
