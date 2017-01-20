class JwtWithNullUser < ApplicationRecord
  devise :database_authenticatable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end
