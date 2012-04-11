#require 'java'

#require(File.join('lib', 'cf.jar'))

#module CfResource
#  import 'ch.ethz.inf.vs.californium.coap.CodeRegistry'
#  import 'ch.ethz.inf.vs.californium.coap.GETRequest'
#  import 'ch.ethz.inf.vs.californium.coap.MediaTypeRegistry'
#  import 'ch.ethz.inf.vs.californium.coap.Response'
#  import 'ch.ethz.inf.vs.californium.endpoint.LocalResource'
#end

class BasicResource < Cf::LocalResource
  
  #def initialize (custom='helloWorld.rb', title='Hello Californium/JRuby!', type='HelloWorldDisplayer')
  def initialize (custom) #, title, type)

    #custom='helloWorld.rb'
    #title='Hello Californium/JRuby!'
    #type='HelloWorldDisplayer'

    @ep = Cf::LocalResource.new(custom) #, title, type)
    #@ep.setTitle(title)
    #@ep.setResourceType(type)
    #@my = title
  end

  def setTitle(string)
    @ep.setTitle(string)
  end

  def setResourceType(string)
    @ep.setResourceType(string)
  end

  def performGET(request)
    response = Cf::Response.new(Cf::CodeRegistry::RESP_CONTENT)
    response.setPayload(@ep.getTitle)
    response.setContentType(Cf::MediaTypeRegistry::TEXT_PLAIN)
    request.respond(response)
  end

end
