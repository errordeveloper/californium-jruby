require(File.join('lib', 'classes', 'server'))

# create the server on default COAP port
x = COAP::Server.new

# supply an RFC6570 template
x.format ("/{section}/{subsection}/{item}")
# define a hash of procedures with methods as
# keys (i.e. `[:get, :put, :delete, :post]`)
# the arguments are:
# - request: the request object
# - element: the path parsed per given template
# - respond: instance of `Responder`
x.router ({
  :get => proc { |request,element,respond|
    respond.as_json(request, element)
  },
  :put => proc { |request,element,respond|
    # This will throw `CR[:not_acceptable]`, i.e. 4.06
    respond.not_acceptable(request)
  },
  :delete => proc { |request,element,respond|
    # This you will throw 5.00, since it's not in CR
    respond.fuck_you(request)
  }
})
