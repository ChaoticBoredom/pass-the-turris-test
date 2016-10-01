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
    url = URI.parse("https://api.login.yahoo.com/oauth2/get_token")
    args = {
      :client_id => Rails.configuration.x.yahoo.client_id,
      :client_secret => Rails.configuration.x.yahoo.client_secret,
      :redirect_uri => confirm_auth_url,
      :code => params.fetch(:code),
      :grant_type => "authorization_code",
    }

    puts params.fetch(:code)
    puts params.fetch("code")
    res = Net::HTTP.post_form(url, args)

    puts "~~~~~~" * 15
    puts res.body
  end

  def success
  end
end
