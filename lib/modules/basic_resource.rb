class BasicResource < Cf::LocalResource
  # All of the arguments are being passed
  # to `LocalResource.new`, so we cannot
  # put more then just this one here :(
  def initialize (custom)
    @ep = Cf::LocalResource.new(custom)
  end
  # We got to wrap it this way for now,
  # which is not too bas anyway ...
  # If you can figure any better way -
  # I'll get you a beer :)
  def setTitle(string)
    @ep.setTitle(string)
  end
  # I did keep the camel case, just for
  # the sake of pseudo compatibility.
  def setResourceType(string)
    @ep.setResourceType(string)
  end
  # And this one just worked, which does
  # make me hapy & I can go to the pub now!
  def performGET(request)
    response = Cf::Response.new(Cf::CodeRegistry::RESP_CONTENT)
    response.setPayload(@ep.getTitle)
    response.setContentType(Cf::MediaTypeRegistry::TEXT_PLAIN)
    request.respond(response)
  end
end
