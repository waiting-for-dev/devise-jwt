# frozen_string_literal: true

shared_context 'fixtures' do
  let(:jwt_with_jti_matcher_model) { JwtWithJtiMatcherUser }
  let(:jwt_with_jti_matcher_user) do
    jwt_with_jti_matcher_model.create(
      email: 'an@user.com',
      password: 'password'
    )
  end

  let(:jwt_with_blacklist_model) { JwtWithBlacklistUser }
  let(:jwt_with_blacklist_user) do
    jwt_with_blacklist_model.create(
      email: 'an@user.com',
      password: 'password'
    )
  end

  let(:jwt_with_whitelist_model) { JwtWithWhitelistUser }
  let(:jwt_with_whitelist_user) do
    jwt_with_whitelist_model.create(
      email: 'an@user.com',
      password: 'password'
    )
  end

  let(:jwt_with_null_model) { JwtWithNullUser }
  let(:jwt_with_null_user) do
    jwt_with_null_model.create(
      email: 'an@user.com',
      password: 'password'
    )
  end

  let(:no_jwt_model) { NoJwtUser }
  let(:no_jwt_user) do
    no_jwt_model.create(
      email: 'an@user.com',
      password: 'password'
    )
  end
end
