class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  def jwt_with_jti_matcher_user_auth_action
    head :ok
  end
  before_action :authenticate_jwt_with_jti_matcher_user!,
                only: :jwt_with_jti_matcher_user_auth_action

  def jwt_with_blacklist_user_auth_action
    head :ok
  end
  before_action :authenticate_jwt_with_blacklist_user!,
                only: :jwt_with_blacklist_user_auth_action

  def jwt_with_whitelist_user_auth_action
    head :ok
  end
  before_action :authenticate_jwt_with_whitelist_user!,
                only: :jwt_with_whitelist_user_auth_action

  def jwt_with_null_user_auth_action
    head :ok
  end
  before_action :authenticate_jwt_with_null_user!,
                only: :jwt_with_null_user_auth_action
end
