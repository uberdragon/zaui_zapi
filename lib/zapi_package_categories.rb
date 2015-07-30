class ZapiPackageCategories

  attr_reader :response, :zapi, :generate_xml, :session

  def initialize session:, zapi: nil, xml_generator: nil
    @zapi = zapi || Zapi.new()
    @generate_xml = xml_generator || ZapiXML.new(session: session)
    @session = session
  end

  def index user_id: session.user_id, api_token: session.api_token
    categories_xml = generate_xml.get_package_categories
    @response = zapi.request(xml: categories_xml)
  end

  def to_a
    # convert received categoires to enumberable array

  end

end
