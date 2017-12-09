class JwtWithWhitelistUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Whitelist

  has_many :jwt_whitelist, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self
end
