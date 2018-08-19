class ZapiXML

  attr_reader :session

  def initialize session: nil
    @session = session
  end

  def agent_login username:, password:
    _wrap_xml_request(
      { "methodName" => 'zapiAgentLogin' },
      { "zapiUsername" => username, "zapiPassword" => password }
    )
  end

  def agents_get_profile agent_id:, agent_hash:
    _wrap_xml_request({
      "methodName" => 'zapiAgents_GetProfile',
      "agentID" => agent_id,
      'agentHashKey' => agent_hash
      })
  end

  def mobile_login username:, password:
    _wrap_xml_request(
      { "methodName" => 'zapiMobileLogin' },
      { "zapiUsername" => username, "zapiPassword" => password }
    )
  end

 def  get_activity_and_product_catalog
    _wrap_xml_request({
      "methodName" => 'zapiGetActivityAndProductCatalog'
    })
  end

  def get_package_categories
    _wrap_xml_request({
      "methodName" => 'zapiGetPackageCategories'
    })
  end

  def get_packages_by_category_id id
    _wrap_xml_request({
      "methodName" => 'zapiGetPackagesByCategoryId',
      "categoryId" => id
    })
  end

  def get_package_details_by_package_id id
    _wrap_xml_request({
      "methodName" => 'zapiGetPackageDetailsByPackageId',
      "packageId" => id
    })
  end

  def add_package_to_cart hash: {}
    _wrap_xml_request({
      "methodName" => "zapiAddPackageToCart",
      "cartId" => session.cart_id,
      "packageId" => hash[:package_id],
      "passengers" => {
        "adults" => hash[:adults].to_i,
        "students" => hash[:students].to_i,
        "children" => hash[:children].to_i
      },
      "activities" => _activities(hash[:activities]),
      "products" => nil
    })
  end

  def get_activity_categories
    _wrap_xml_request({
      "methodName" => 'zapiGetActivityCategories'
    })
  end

  def get_activities_by_category_id id
    _wrap_xml_request({
      "methodName" => 'zapiGetActivitiesByCategoryId',
      "categoryId" => id
    })
  end

  def get_merchandise_categories
    _wrap_xml_request({
      "methodName" => 'zapiGetMerchandiseCategories'
    })
  end

  def get_merchandise_by_category_id id
    _wrap_xml_request({
      "methodName" => 'zapiGetMerchandiseByCategoryId',
      "categoryId" => id
    })
  end

  def clear_cart_session
    _wrap_xml_request({
      "methodName" => 'zapiClearCartSession',
      "cartId" => session.cart_id
    })
  end

  def get_cart_contents
    raw = _wrap_xml_request({
      "methodName" => 'zapiGetCartContents',
      "cartId" => session.cart_id
    })
  end

  def update_notes_to_cart notes
    _wrap_xml_request({
      "methodName" => 'zapiUpdateNotesToCart',
      "cartId" => session.cart_id,
      "notes" => notes
    })
  end

  def update_customer_details_to_cart first_name:, last_name:, phone:, email:
    _wrap_xml_request({
      "methodName" => 'zapiUpdateCustomerDetailsToCart',
      "cartId" => session.cart_id,
      "firstName" => first_name,
      "lastName" => last_name,
      "mobileNumber" => phone,
      "email" => email
    })
  end

  def add_product_to_cart product_id:, quantity:
    _wrap_xml_request({
      "methodName" => 'zapiAddProductToCart',
      "cartId" => session.cart_id,
      "productId" => product_id,
      "quantity" => quantity
    })
  end

  def remove_product_cart_item product_id:
    _wrap_xml_request({
      "methodName" => 'zapiRemoveProductCartItem',
      "cartId" => session.cart_id,
      "productId" => product_id
    })
  end

  def get_all_merchandise_by_name product_name:
    _wrap_xml_request({
      "methodName" => 'zapiGetAllMerchandiseByName',
      "productNameToSearch" => product_name
    })
  end

  def get_all_activities_by_name activity_name:
    _wrap_xml_request({
      "methodName" => 'zapiGetAllActivitiesByName',
      "activityNameToSearch" => activity_name
    })
  end

  def get_all_activities_by_date date:
    _wrap_xml_request({
      "methodName" => 'zapiGetAllActivitiesByDate',
      "activityDate" => date.strftime("%Y-%m-%d")
    })
  end

  def price_quote activity_date:, activity_id:, pickup_location_id:, passengers: {}
    _wrap_xml_request({
      "methodName" => 'zapiPriceQuote',
      "activityId" => activity_id,
      "activityDate" => activity_date.strftime("%Y-%m-%d"),
      "passengers" => {
        "seniors" => passengers[:seniors].to_i,
        "adults" => passengers[:adults].to_i,
        "students" => passengers[:students].to_i,
        "children" => passengers[:children].to_i,
        "infants" => passengers[:infants].to_i
      },
      "pickupLocationId" => pickup_location_id
    })
  end

  def add_activity_to_cart hash: {}
    for_xml = {
      "methodName" => 'zapiAddActivityToCart',
      "cartId" => session.cart_id,
      "activityId" => hash[:activity_id],
      "activityDate" => hash[:activity_date],
      "activityEndDate" => hash[:activity_end_date],
      "rentalStartTime" => hash[:rental_start_time],
      "rentalEndTime" => hash[:rental_end_time],
      "pricingOptions" => nil,
      "passengers" => {
      },
      "activityTime" => hash[:activity_time],
      "pickupLocationId" => nil,
      "dropOffLocationId" => hash[:dropoff_location_id]
    }


    for_xml['passengers']['adults'] = hash[:adults].to_i unless hash[:adults].to_i == 0
    for_xml['passengers']['children'] = hash[:children].to_i unless hash[:children].to_i == 0
    for_xml['passengers']['infants'] = hash[:infants].to_i unless hash[:infants].to_i == 0
    for_xml['pickupLocationId'] = hash[:pickup_location_id].to_i unless hash[:pickup_location_id].blank?

    _wrap_xml_request(for_xml)
  end

  def remove_activity_cart_item activity_id:, date: nil
    date = date.strftime("%Y-%m-%d") if date.is_a? Date

    _wrap_xml_request({
      "methodName" => 'zapiRemoveActivityCartItem',
      "cartId" => session.cart_id,
      "activityId" => activity_id,
      "activityDate" => date
    })
  end

  def get_activity_details_by_activity_id id, date: nil
    hash = {
      "methodName" => 'zapiGetActivityDetailsByActivityId',
      "activityId" => id
    }
    if date
      hash.merge!({
        "activityDate" => date
      })
    end
    _wrap_xml_request(hash)
  end

  def get_product_details_by_product_id id
    _wrap_xml_request({
      "methodName" => 'zapiGetProductDetailsByProductId',
      "productId" => id
    })
  end

  def check_activity_inventory_by_date hash: {}
    _wrap_xml_request({
      "methodName" => 'zapiCheckActivityInventoryByDate',
      "activityId" => hash[:activity_id],
      "activityDate" => hash[:activity_date],
      "activityTime" => hash[:activity_time],
      "pickupLocationId" => hash[:pickup_location_id],
      "dropoffLocationId" => hash[:dropoff_location_id],
      "requestedPassengers" => {
        "seniors" => hash[:seniors],
        "adults" => hash[:adults],
        "students" => hash[:students],
        "children" => hash[:children],
        "infants" => hash[:infants]
      },
      "pricingOptions" => {
        "option" => {
          "optionId" => hash[:option_id],
          "quantity" => hash[:quantity]
        }
      }
    })
  end

  def check_product_inventory product_id:, quantity:
    _wrap_xml_request({
      "methodName" => 'zapiCheckProductInventory',
      "productId" => product_id,
      "quantity" => quantity
    })
  end

  def process_cart_with_payment hash:
    _wrap_xml_request({
      "methodName" => 'zapiProcessCartWithPayment',
      "cartId" => session.cart_id,
      "paymentMethod" => {
        "paymentMethodType" => 2000
      },
      "paymentGatewayId" => nil,
      "creditCardDetails" => {
        "nameOnCard" => hash[:name_on_card],
        "number" => hash[:cc_num],
        "expMonth" => hash[:expiration_month],
        "expYear" => hash[:expiration_year],
        "csv" => hash[:csv],
        "cardType" => hash[:card_type],
        "rawSwipeData" => nil,
        "track1Data" => nil,
        "track2Data" => nil
      }
    })
  end

  def promotion_code_apply promo_code:
    foo = _wrap_xml_request({
      "methodName" => 'zapiPromotionCodeApply',
      "cartId" => session.cart_id,
      "promoCodeName" => promo_code
    })
  end

  def process_single_transaction hash:
    _wrap_xml_request({
      "methodName" => 'zapiProcessSingleTransaction',
      "cartId" => session.cart_id,
      "transactionDetails" => {
        "transactionType" => 2000,
        "transactionAmount" => hash[:amount],
        "creditCardDetails" => {
          "nameOnCard" => hash[:name_on_card],
          "number" => hash[:cc_num],
          "expMonth" => hash[:expiration_month],
          "expYear" => hash[:expiration_year],
          "csv" => hash[:csv],
          "cardType" => hash[:card_type],
          "rawSwipeData" => nil,
          "track1Data" => nil,
          "track2Data" => nil
        }
      }
    })
  end

  def email_booking_itinerary booking_number:
    _wrap_xml_request({
      "methodName" => "zapiEmailBookingItinerary",
      "bookingNumber" => booking_number
    })
  end

  def load_booking_into_cart booking_number:
    _wrap_xml_request({
      "methodName" => "zapiLoadBookingIntoCart",
      "bookingNumber" => booking_number
    })
  end

  def gift_certificate_apply gift_certificate:
    _wrap_xml_request({
      "methodName" => 'zapiGiftCertificateApply',
      "cartId" => session.cart_id,
      "giftCertificate" => gift_certificate
    })
  end

  def get_manifest_entire_day_by_date date:
    _wrap_xml_request({
      "methodName" => 'zapiGetManifestEntireDayByDate',
      "date" => date
    })
  end

  def _wrap_xml_request method, params = {}
    if session
      request = params.merge({
        'zapiToken' => session.api_token,
        'zapiUserId' => session.user_id,
        'zapiAccountId' => session.account_id,
        'zapiMethod' => method
      })
    else
      request = params.merge({ 'zapiMethod' => method })
    end
    request.to_xml(:root => 'request')
  end

  def _activities activities
    activites.map do |a|
      {
        "activityId" => nil,
        "activityDate" => nil,
        "activityTime" => nil,
        "pickupLocationId" => nil,
        "pickupAddress" => nil,
        "dropOffLocationId" => nil,
        "dropoffAddress" => nil,
        "pricingOptions" => nil
      }
    end
    {'activity' => activities}
  end

end
