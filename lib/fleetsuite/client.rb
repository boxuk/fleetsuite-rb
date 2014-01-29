require 'httparty'

module Fleetsuite

  class Client

    include HTTParty

    attr_accessor :subdomain,
                  :token,
                  :endpoint

    def initialize(subdomain, token)
      @subdomain = subdomain
      @token     = token
      @endpoint  = "https://#{@subdomain}.fleetsuite.com/api/v1"
    end

    def parse_response(response)
      case response.code
      when 200
        JSON.parse(response.body)
      else
        { error: "Bad request: #{response.code}" }
      end
    end

    def request_with_auth(url, opts={})
      auth_opts = {
        headers: { "Authorization" => "Token token=#{@token}" }
      }
      options = auth_opts.merge(opts)
      parse_response( HTTParty.get(url, options) )
    end

    def endpoint_for(resource, params={})
      default_args = [@endpoint, resource.to_s]
      if params.include?(:id)
        "%s/%s/%s.json" % default_args.push(params[:id])
      else
        "%s/%s.json" % default_args
      end
    end

    # Fetch all projects for the current user
    #
    def projects(params={})
      resource = endpoint_for(:projects)
      request_with_auth(resource)
    end

    def cached_projects(params={})
      @cached_projects ||= projects(params)
    end

    # Fetch a single project by ID
    #
    def project(project_id, params={})
      resource = endpoint_for(:projects, { id: project_id })
      response = request_with_auth(resource)
      if response.include?(:error)
        { error: "Bad request #{response.code}" }
      else
        response["project"]
      end
    end

    def project_by(attr, value, params={})
      projects ||= cached_projects
      projects.inject([]) { |r, project|
        r.push(project) if project["name"].downcase.strip == project_name.downcase.strip
      }
    end
  end
end
