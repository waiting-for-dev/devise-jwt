# frozen_string_literal: true

shared_context 'feature' do
  def auth_headers(auth)
    {
      'Authorization' => auth,
      'Accept' => 'application/json'
    }
  end

  def sign_in(session_path, params)
    post(session_path, params: params)
    response.headers['Authorization']
  end

  def sign_up(registration_path, params)
    post(registration_path, params: params)
  end

  def sign_out(destroy_session_path, auth, method = :delete)
    send(method, destroy_session_path,
         headers: auth_headers(auth))
  end

  def get_with_auth(path, auth)
    get(path,
        headers: auth_headers(auth))
  end
end
