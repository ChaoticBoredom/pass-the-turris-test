require "net/http"

class AuthorizationController < ApplicationController
  def login
    url = URI.parse("https://api.login.yahoo.com/oauth2/request_auth")
    args = {
      :client_id => Rails.configuration.x.yahoo.client_id,
      :redirect_uri => confirm_auth_url,
      :response_type => "code",
    }

    url.query = URI.encode_www_form(args)
    res = Net::HTTP.get_response(url)
    redirect_to res.fetch("location")
  end

  def confirm_auth
    Session.new.create_session(params.fetch("code"))
  end
end
