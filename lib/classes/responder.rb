## We use `json-jruby` gem, it's apparently fast :)
require 'json'
## A little helper class which is kind of nice :)
module COAP
  class Responder
    ## Just wrap arround `Cf::Response` so we can
    ## define some custome methods as shown below
    def initialize
      @res = Cf::Response.new
      @res.set_content_type(MT[:json])
    end
    ## Define our most usefull response method
    def as_json(req, obj)
      @res.set_payload(obj.to_json)
      req.respond(@res)
    end
    ## Any undefined method is treated as key to
    ## the code registry (CR)
    def method_missing(m, req)
      unless CR[m].nil?
        req.respond(CR[m])
      else
        req.respond(CR[:internal_server_error])
      end
    end
  end
end
