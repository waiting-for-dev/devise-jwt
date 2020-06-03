# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT::MappingInspector do
  let(:jwt_with_jti_matcher_inspector) do
    described_class.new(:jwt_with_jti_matcher_user)
  end

  let(:jwt_with_null_inspector) do
    described_class.new(:jwt_with_null_user)
  end

  let(:jwt_with_denylist_inspector) do
    described_class.new(:jwt_with_denylist_user)
  end

  let(:jwt_with_allowlist_inspector) do
    described_class.new(:jwt_with_allowlist_user)
  end

  let(:no_jwt_inspector) { described_class.new(:no_jwt_user) }

  describe '#jwt?' do
    context 'when jwt_authenticatable module is included' do
      it 'returns true' do
        expect(jwt_with_jti_matcher_inspector.jwt?).to eq(true)
      end
    end

    context 'when jwt_authenticatable module is not included' do
      it 'returns false' do
        expect(no_jwt_inspector.jwt?).to eq(false)
      end
    end
  end

  describe '#session?' do
    context 'when session routes are included' do
      it 'returns true' do
        expect(jwt_with_jti_matcher_inspector.session?).to eq(true)
      end
    end

    context 'when session routes are not included' do
      it 'returns true' do
        jwt_with_jti_matcher_inspector.mapping.routes.delete(:session)

        expect(jwt_with_jti_matcher_inspector.session?).to eq(false)
      end
    end
  end

  describe '#registration?' do
    context 'when registration routes are included' do
      it 'returns true' do
        expect(jwt_with_jti_matcher_inspector.registration?).to eq(true)
      end
    end

    context 'when registration routes are not included' do
      it 'returns true' do
        jwt_with_jti_matcher_inspector.mapping.routes.delete(:registration)

        expect(jwt_with_jti_matcher_inspector.registration?).to eq(false)
      end
    end
  end

  describe '#model' do
    it 'returns associated model' do
      expect(jwt_with_jti_matcher_inspector.model).to eq(JwtWithJtiMatcherUser)
    end
  end

  describe '#path' do
    it 'returns path for given name' do
      expect(jwt_with_jti_matcher_inspector.path(:sign_in)).to eq(
        '/jwt_with_jti_matcher_users/sign_in'
      )
    end

    it 'respects scope parts' do
      expect(jwt_with_null_inspector.path(:sign_in)).to eq(
        '/a/scope/jwt_with_null_users/sign_in'
      )
    end
  end

  describe '#methods' do
    context 'when name is :sign_in' do
      it "returns ['POST']" do
        expect(jwt_with_jti_matcher_inspector.methods(:sign_in)).to eq(['POST'])
      end
    end

    context 'when name is :registration' do
      it "returns ['POST']" do
        expect(jwt_with_jti_matcher_inspector.methods(:registration)).to eq(
          ['POST']
        )
      end
    end

    context 'when name is :sign_out' do
      it 'returns mapping sign_out_via option as upcased string' do
        expect(jwt_with_jti_matcher_inspector.methods(:sign_out)).to eq(
          ['DELETE']
        )
      end

      it 'respects when sign_out_via option is not the default' do
        expect(jwt_with_denylist_inspector.methods(:sign_out)).to eq(
          ['POST']
        )
      end

      it 'accepts sign_out_via option when it contains multiple methods' do
        expect(jwt_with_allowlist_inspector.methods(:sign_out)).to match_array(
          %w[GET DELETE]
        )
      end
    end
  end

  describe '#formats' do
    context 'when scope has no configured formats' do
      it 'returns an array with a nil element' do
        expect(jwt_with_jti_matcher_inspector.formats).to eq([nil])
      end
    end

    context 'when scope has configured formats' do
      it 'returns them' do
        expect(jwt_with_denylist_inspector.formats).to eq(%i[json xml])
      end
    end
  end
end
