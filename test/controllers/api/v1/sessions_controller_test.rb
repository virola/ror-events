require 'test_helper'

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  appid = 'wx0994caa77289475b'
  appsecret = '93a06bfcedcc18d057ee36f3d59b4de0'
  code = '071B9Zzd0EaL0u1Rjlzd0bBMzd0B9Zze'

  url = 'https://api.weixin.qq.com/sns/jscode2session' + "?appid=#{appid}&secret=#{appsecret}&js_code=#{code}&grant_type=authorization_code"

  response = HTTParty.get(url)
  puts response.body, response.code, response.message, response.headers.inspect
end
