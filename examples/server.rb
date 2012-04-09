require 'java'
require(File.join(File.dirname(__FILE__), '..', 'lib', 'cf.jar'))

module Cf
  import 'ch.ethz.inf.vs.californium.coap'
  import 'ch.ethz.inf.vs.californium.endpoint'
  import 'ch.ethz.inf.vs.californium.examples.resources'
  import 'ch.ethz.inf.vs.californium.util'
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
