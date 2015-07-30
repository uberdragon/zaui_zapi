class ZapiXML

  def agent_login username:, password:
    _wrap_xml_request({
      zapiUsername: username,
      zapiPassword: password,
      zapiMethod: {
        methodName: 'zapiAgentLogin',
      }
    })
  end

  def mobile_login username:, password:
    _wrap_xml_request({
      zapiUsername: username,
      zapiPassword: password,
      zapiMethod: {
        methodName: 'zapiMobileLogin',
        mobileData: {
          mobileDeviceData: {
            model: '',
            name: '',
            systemName: '',
            systemVersion: ''
          },
          iosLocationServiceData: {
            altitude: '',
            coordinate: '',
            course: '',
            horizontalAccuracy: '',
            verticalAccuracy: '',
            speed: '',
            timeStamp: '',
          }
        }
      }
    })
  end

  def get_activity_categories user_id:, api_token:
    _wrap_xml_request({
      zapiToken: api_token,
      zapiUserId: user_id,
      zapiMethod: {
        methodName: 'zapiGetActivityCategories'
      }
    })
  end

  def _wrap_xml_request hash
    hash.to_xml(:root => 'request')
  end

end
