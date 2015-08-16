class Zaui

  attr_reader :zapi, :xml, :responder

  def initialize zapi: nil, zapi_xml: nil, responder: nil, session: nil
    @zapi = zapi || Zapi.new()
    @xml = zapi_xml || ZapiXML.new(session: ZapiObject.new(hash: session))
    @responder = responder || ZapiObject
  end

  def get_activity_categories
    raw = _zapi(xml.get_activity_categories).try(:[],'categories').try(:[],'category')
  end

  def get_activities_by_category_id id
    raw = _zapi(xml.get_activities_by_category_id(id)).try(:[],'activities').try(:[],'activity')
  end

  def get_activity_details_by_activity_id id
    raw = _zapi(xml.get_activity_details_by_activity_id(id)).try(:[],'activity')
  end

  def add_activity_to_cart id:, date:, passengers: {adults: 0, children: 0, infants: 0}
    hash = {
      activity_id: id,
      activity_date: date,
      adults: passengers[:adults],
      children: passengers[:children],
      infants: passengers[:infants]
    }

    raw = _zapi(xml.add_activity_to_cart(hash: hash))
  end

  def get_cart_contents
    activities = _zapi(xml.get_cart_contents).try(:[],'cart').try(:[],'activities').try(:[],'activity')
    activities.is_a?(Array) ? activities : [activities]
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
