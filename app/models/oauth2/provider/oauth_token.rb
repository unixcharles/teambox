# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    class OauthToken < ::ActiveRecord::Base

      belongs_to :oauth_client, :class_name => "Oauth2::Provider::OauthClient"
  
      EXPIRY_TIME = 90.days
  
      def access_token_attributes
        {:access_token => access_token, :expires_in => expires_in, :refresh_token => refresh_token}
      end
  
      def expires_in
        (Time.at(expires_at.to_i) - Clock.now).to_i
      end
  
      def expired?
        expires_in <= 0
      end
      
      def refresh
        self.delete
        oauth_client.create_token_for_user_id(user_id)
      end

      protected
      def before_create
        self.access_token = ActiveSupport::SecureRandom.hex(32)
        self.expires_at = Clock.now + EXPIRY_TIME
        self.refresh_token = ActiveSupport::SecureRandom.hex(32)
      end
  
    end
  end
end