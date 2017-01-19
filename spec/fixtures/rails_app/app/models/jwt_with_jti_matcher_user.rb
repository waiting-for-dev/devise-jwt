class JwtWithJtiMatcherUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
end
