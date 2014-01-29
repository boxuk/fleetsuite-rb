require 'httparty'

module Fleetsuite
  class Client
    include HTTParty
    API_VERSION = "v1"
    
    attr_accessor :subdomain, 
                  :token, 
                  :endpoint

    def initialize(subdomain, token)
      @subdomain = subdomain
      @token   = token
      @endpoint = "https://#{@subdomain}.fleetsuite.com/api/#{API_VERSION}"
    end

    def request_with_auth(url, opts={})
      auth_opts = {
        headers: { "Authorization" => "Token token=#{@token}" }
      }
      options = auth_opts.merge(opts)
      response = HTTParty.get(url, options)
      case response.code
      when 200
        JSON.parse(response.body)
      else
        { error: "Bad request" }
      end
    end

    def endpoint_for(resource)
      "%s/%s.json" % [@endpoint, resource.to_s]
    end

    def projects(params={})
      url = endpoint_for(:projects)
      request_with_auth(url)
    end
  end
end
