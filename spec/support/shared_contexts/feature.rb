# frozen_string_literal: true

shared_context 'feature' do
  def auth_headers(auth)
    {
      'Authorization' => auth,
      'Accept' => 'application/json'
    }
  end

  def sign_in(session_path, params, format: nil)
    path = format ? session_path + ".#{format}" : session_path
    post(path, params: params)
    response.headers['Authorization']
  end

  def sign_up(registration_path, params, format: nil)
    path = format ? registration_path + ".#{format}" : registration_path
    post(path, params: params)
  end

  # :reek:LongParameterList
  def sign_out(destroy_session_path, auth, method = :delete, format: nil)
    path = format ? destroy_session_path + ".#{format}" : destroy_session_path
    send(method, path, headers: auth_headers(auth))
  end

  def get_with_auth(path, auth)
    get(path,
        headers: auth_headers(auth))
  end
end
