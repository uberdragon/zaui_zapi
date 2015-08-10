class ZapiAgent

  attr_reader :response, :zapi, :generate_xml, :responder

  def initialize username:, password:, zapi: nil, xml_generator: nil, responder: nil
    @zapi = zapi || Zapi.new()
    @generate_xml = xml_generator  || ZapiXML.new()
    @responder = responder || ZapiObject
    @response = _login username: username, password: password
  end

  def is_logged_in?
    response_msg == "Login Successful" && _method_name == 'zapiAgentLogin'
  end

  def response_msg
    response.try(:[],'methodErrorMessage')
  end

  def session_hash
    {
      user_id: _user_id,
      account_id: _account_id,
      account_type: _account_type,
      cart_id: _cart_id,
      api_token: _api_token,
      username: _username,
      firstname: _firstname,
      lastname: _lastname,
      fullname: _fullname
    }
  end

  def session hash: session_hash
    responder.new(session_hash: hash)
  end

  def _login username:, password:
    login_xml = generate_xml.agent_login(username: username, password: password)
    zapi.request(xml: login_xml)
  end

  def _user_id
    response.try(:[],'zapiUserId').to_i
  end

  def _account_id
    response.try(:[],'zapiAccountId').to_i
  end

  def _account_type
    response.try(:[],'zapiAccountType').to_i
  end

  def _cart_id
    response.try(:[],'cartId')
  end

  def _api_token
    response.try(:[],'zapiApiToken')
  end

  def _username
    response.try(:[],'zapiUsername')
  end

  def _firstname
    response.try(:[],'firstName')
  end

  def _lastname
    response.try(:[],'lastName')
  end

  def _fullname
    [_firstname, _lastname].compact.join(" ") if _firstname || _lastname
  end

  def _method_name
    response.try(:[],'methodName')
  end

end
