Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml,
    attribute_service_name: ENV.fetch("SAML_SP_SERVICE_NAME", "Digital Repository"),
    assertion_consumer_service_url: ENV["SAML_SP_ASSERTION_CONSUMER_SERVICE_URL"],
    sp_entity_id: ENV["SAML_SP_ENTITY_ID"],
    idp_sso_service_url: ENV["SAML_IDP_SSO_SERVICE_URL"],
    slo_enabled: false,
    idp_cert: ENV["SAML_IDP_CERT"],
    name_identifier_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  end
