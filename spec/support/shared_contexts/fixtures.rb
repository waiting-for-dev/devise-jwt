# frozen_string_literal: true

shared_context 'fixtures' do
  let(:jwt_with_jti_matcher_model) { JwtWithJtiMatcherUser }
  let(:jwt_with_jti_matcher_user) do
    jwt_with_jti_matcher_model.create(
      email: 'an@user.com',
      password: 'password'
    )
  end

  let(:jwt_with_denylist_model) { JwtWithDenylistUser }
  let(:jwt_with_denylist_user) do
    jwt_with_denylist_model.create(
      email: 'an@user.com',
      password: 'password'
    )
  end

  let(:jwt_with_allowlist_model) { JwtWithAllowlistUser }
  let(:jwt_with_allowlist_user) do
    jwt_with_allowlist_model.create(
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
