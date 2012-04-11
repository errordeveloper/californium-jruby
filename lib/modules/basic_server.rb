require 'java'

require(File.join('lib', 'cf.jar'))

module Cf
  import 'ch.ethz.inf.vs.californium.coap'
  import 'ch.ethz.inf.vs.californium.endpoint'
  import 'ch.ethz.inf.vs.californium.examples.resources'
  import 'ch.ethz.inf.vs.californium.util'
end
