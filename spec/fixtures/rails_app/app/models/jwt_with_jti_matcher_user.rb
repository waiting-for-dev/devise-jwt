class JwtWithJtiMatcherUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
end
