module Instagram
  module Constants
    PRIVATE_KEY = {
        SIG_KEY: '0443b39a54b05f064a4917a3d1da4d6524a3fb0878eacabf1424515051674daa'.freeze,
        SIG_VERSION: '4'.freeze,
        APP_VERSION: '10.33.0'.freeze
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
