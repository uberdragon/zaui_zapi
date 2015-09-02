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

  def add_activity_to_cart id:, date:, passengers: {adults: 0, children: 0, infants: 0}, location_id: nil
    hash = {
      activity_id: id,
      activity_date: date,
      adults: passengers[:adults],
      children: passengers[:children],
      infants: passengers[:infants],
      pickup_location_id: location_id
    }

    raw = _zapi(xml.add_activity_to_cart(hash: hash))
  end

  def remove_activity_cart_item id:, date: nil
    raw = _zapi(xml.remove_activity_cart_item(activity_id: id, date: date))
  end

  def get_cart_contents
    activities = _zapi(xml.get_cart_contents).try(:[],'cart').try(:[],'activities').try(:[],'activity')
    activities.is_a?(Array) ? activities : [activities]
  end

  def update_customer_details_to_cart first_name:, last_name:, phone:, email:
    request = xml.update_customer_details_to_cart(
       first_name: first_name,
       last_name: last_name,
       phone: phone,
       email: email
    )
    raw = _zapi(request)
  end

  def promotion_code_apply code:
    raw = _zapi(xml.promotion_code_apply(promo_code: code))
  end

  def process_cart_with_payment hash: {}
    cart_data = {
      name_on_card: hash[:name_on_card],
      cc_num: hash[:cc_num].gsub(/[^\d]/, ''),
      expiration_month: hash[:expiration_month],
      expiration_year: hash[:expiration_year],
      csv: hash[:csv]
    }
    raw = _zapi(xml.process_cart_with_payment(hash: cart_data))
  end

  def get_package_categories
    raw = _zapi(xml.get_package_categories)[:categories][:category]
  end

  def get_packages_by_category_id id
    raw = _zapi(xml.get_packages_by_category_id(id))
  end

  def check_activity_inventory_by_date hash:
    inventory_data = {
      activity_id: hash[:activity_id],
      activity_date: hash[:activity_date],
      adults: hash[:adults],
      children: hash[:children],
      infants: hash[:infants]
    }
    raw = _zapi(xml.check_activity_inventory_by_date(hash: inventory_data))
  end

  def clear_cart_session
    raw = _zapi(xml.clear_cart_session)
  end

  def _zapi xml
    zapi.request(xml: xml)
  end

end
