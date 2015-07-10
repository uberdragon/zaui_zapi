class Zapi::ZapiResponse

  attr_reader :raw_response

  def initialize raw_response:
    @raw_response = raw_response
  end

  def raw_xml
    raw_response.body
  end

  def raw_hash
    Hash.from_xml raw_xml
  end

  def api_version
    _response.try(:[],'zapiVersion')
  end

  def method_name
    data.try(:[],'methodName')
  end

  def data
     _response.try(:[],'methodResponse')
  end

  def _response
    raw_hash.try(:[], 'response')
  end
end
