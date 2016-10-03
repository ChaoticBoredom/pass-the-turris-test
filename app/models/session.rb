class Session < ActiveRecord::Base
  def create_session(code)
    args = {
      :code => code,
      :grant_type => "authorization_code",
    }

    res = get_token_call(args)

    create!(
      :refresh_token => res.fetch("refresh_token"),
      :expiry_at => res.fetch("expires_in").seconds.from_now,
      :guid => res.fetch("xoauth_yahoo_guid")
    )
  end

  def refresh_session
    args = {
      :refresh_token => refresh_token,
      :grant_type => "refresh_token",
    }

    res = get_token_call(args)

    update_attributes(
      :refresh_token => res.fetch("refresh_token"),
      :expiry_at => res.fetch("expires_in").seconds.from_now
    )
  end

  private

  def get_token_call(additional_args)
    url = URI.parse("https://api.login.yahoo.com/oauth2/get_token")
    args = {
      :client_id => Rails.configuration.x.yahoo.client_id,
      :client_secret => Rails.configuration.x.yahoo.client_secret,
      :redirect_uri => Rails.application.routes.url_helpers.confirm_auth_url(
        :host => Rails.configuration.x.hostname
      ),
    }

    args = args.merge(additional_args)

    res = Net::HTTP.post_form(url, args)
    puts res.fetch("refresh_token", "NOPE")
    puts res
    res
  end
end
