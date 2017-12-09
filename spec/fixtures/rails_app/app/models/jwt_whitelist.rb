class JwtWhitelist < ApplicationRecord
  self.table_name = 'jwt_whitelist'

  validate :jti, :aud, presence: true
  validate :jti, uniqueness: true
end
