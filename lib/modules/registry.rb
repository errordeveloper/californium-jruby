CR = { # TODO: put all of the codes here
  :not_found                  =>Cf::CodeRegistry::RESP_NOT_FOUND,
  :deleted                    =>Cf::CodeRegistry::RESP_DELETED,
  :created                    =>Cf::CodeRegistry::RESP_CREATED,
  :bad_request                =>Cf::CodeRegistry::RESP_BAD_REQUEST,
  :bad_option                 =>Cf::CodeRegistry::RESP_BAD_OPTION,
  :bad_gatewat                =>Cf::CodeRegistry::RESP_BAD_GATEWAY,
  :forbidden                  =>Cf::CodeRegistry::RESP_FORBIDDEN,
  :unauthorized               =>Cf::CodeRegistry::RESP_UNAUTHORIZED,
  :precondition_faild         =>Cf::CodeRegistry::RESP_PRECONDITION_FAILED,
  :valid                      =>Cf::CodeRegistry::RESP_VALID,
  :changed                    =>Cf::CodeRegistry::RESP_CHANGED,
  :content                    =>Cf::CodeRegistry::RESP_CONTENT,
  :service_unavailable        =>Cf::CodeRegistry::RESP_SERVICE_UNAVAILABLE,
  :unsupported_media_type     =>Cf::CodeRegistry::RESP_UNSUPPORTED_MEDIA_TYPE,
  :internal_server_error      =>Cf::CodeRegistry::RESP_INTERNAL_SERVER_ERROR,
  :not_implemented            =>Cf::CodeRegistry::RESP_NOT_IMPLEMENTED,
  :not_acceptable             =>Cf::CodeRegistry::RESP_NOT_ACCEPTABLE,
}

MT = {
  :json                       =>Cf::MediaTypeRegistry::APPLICATION_JSON,
}

