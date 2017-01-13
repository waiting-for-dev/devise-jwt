class JwtUser < ApplicationRecord
  include Devise::JWT::Models::JWTAuthenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :validatable
end
