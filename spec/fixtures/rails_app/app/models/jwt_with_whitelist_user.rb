class JwtWithWhitelistUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Whitelist

  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self
end
