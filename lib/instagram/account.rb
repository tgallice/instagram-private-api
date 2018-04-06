module Instagram
  module Account
    def self.login(user, login_attempt = 0)
      response = Instagram::API.post_request(
        user,
        'accounts/login/',
        {
          phone_id: user.phone_id,
          device_id: user.device_id,
          login_attempt_user: login_attempt,
          password: user.password,
          username: user.username,
          adid: user.advertising_id,
          guid: user.uuid
        },
        true
      )

      json_body = response.json_body
      logged_in_user = json_body['logged_in_user']
      user.data = {
        id: logged_in_user['pk'],
        full_name: logged_in_user['full_name'],
        is_private: logged_in_user['is_private'],
        profile_pic_url: logged_in_user['profile_pic_url'],
        profile_pic_id: logged_in_user['profile_pic_id'],
        is_verified: logged_in_user['is_verified'],
        is_business: logged_in_user['is_business']
      }
      cookies_array = []
      all_cookies = response.raw_response.get_fields('set-cookie')
      all_cookies.each do |cookie|
        cookies_array.push(cookie.split('; ')[0])
      end
      cookies = cookies_array.join('; ')
      user.session = cookies
    end

    def self.search_for_user(user, username)
      rank_token = Instagram::API.generate_rank_token user.session.scan(/ds_user_id=([\d]+);/)[0][0]
      endpoint = 'https://i.instagram.com/api/v1/users/search/'
      param = format('?is_typehead=true&q=%s&rank_token=%s', username, rank_token)
      result = Instagram::API.http(
        url: endpoint + param,
        method: 'GET',
        user: user
      )

      json_result = result.json_body
      if json_result['num_results'] > 0
        user_result = json_result['users'][0]
        user_object = Instagram::User.new username, nil
        user_object.data = {
          id: user_result['pk'],
          full_name: user_result['full_name'],
          is_private: user_result['is_prive'],
          profile_pic_url: user_result['profile_pic_url'],
          profile_pic_id: user_result['profile_pic_id'],
          is_verified: user_result['is_verified'],
          is_business: user_result['is_business']
        }
        user_object.session = user.session
        user_object
      end
    end
  end
end
