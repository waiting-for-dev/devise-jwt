class JwtWithBlacklistUser < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Blacklist
end
