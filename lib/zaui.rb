class Zaui

  attr_reader :zapi, :xml, :responder

  def initialize zapi: nil, zapi_xml: nil, responder: nil, session: nil
    @zapi = zapi || Zapi.new()
    @xml = zapi_xml || ZapiXML.new(session: ZapiObject.new(hash: session))
    @responder = responder || ZapiObject
  end

  def get_activity_categories
    raw = _zapi(xml.get_activity_categories)[:categories][:category]
  end

  def get_activities_by_category_id id
    raw = _zapi(xml.get_activities_by_category_id(id))[:activities][:activity]
  end

  def get_package_categories
    raw = _zapi xml.get_package_categories[:categories][:category]
  end

  def get_packages_by_category_id id
    raw = _zapi(xml.get_packages_by_category_id(id))
  end

  def _zapi xml
    zapi.request(xml: xml)
  end

end
