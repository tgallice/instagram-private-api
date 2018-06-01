module Instagram
  module Constants
    PRIVATE_KEY = {
        SIG_KEY: '109513c04303341a7daf27bb41b268e633b30dcc65a3fe14503f743176113869'.freeze,
        SIG_VERSION: '4'.freeze,
        APP_VERSION: '27.0.0.7.97'.freeze
    }.freeze

    HEADER = {
        capabilities: '3QI='.freeze,
        type: 'WIFI'.freeze,
        host: 'i.instagram.com'.freeze,
        connection: 'Close'.freeze,
        encoding: 'gzip, deflate, sdch'.freeze,
        accept: '*/*'.freeze,
        content_type: 'application/x-www-form-urlencoded; charset=UTF-8'.freeze
    }

    URL = 'https://i.instagram.com/api/v1/'.freeze
    FB_HTTP_ENGINE = 'Liger'.freeze
  end
end
