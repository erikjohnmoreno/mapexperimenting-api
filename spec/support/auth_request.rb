[:get, :patch, :put, :post, :delete].each do |method|

  define_method "auth_#{method}" do |path, params={}, headers={}|
    _headers = {
      Authorization: "Authorization: #{JsonWebToken::encode(user_id: current_user.id)}"
    }.merge(headers)

    send(method, path, params: params, headers: _headers)
  end

end
