require 'java'

require(File.join('..', 'cf.jar'))

module Cf
  import 'ch.ethz.inf.vs.californium.coap'
  import 'ch.ethz.inf.vs.californium.endpoint'
  import 'ch.ethz.inf.vs.californium.util'
  import 'java.util.logging.Level'
  import 'java.net.URI'
end
