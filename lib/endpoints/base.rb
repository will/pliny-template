module Endpoints
  # The base class for all Sinatra-based endpoints. Use sparingly.
  class Base < Sinatra::Base
    register Pliny::Extensions::Instruments
    register Sinatra::Namespace

    helpers Pliny::Helpers::Params

    set :dump_errors, false
    set :raise_errors, true
    set :show_exceptions, false

    configure :development do
      register Sinatra::Reloader
    end

    error Pliny::Errors::Error do
      Pliny::Errors::Error.render(env["sinatra.error"])
    end

    not_found do
      content_type :json
      status 404
      "{}"
    end

    private

    def encode(hash)
      MultiJson.encode(hash, pretty: development? || params[:pretty] == 'true')
    end
  end
end
