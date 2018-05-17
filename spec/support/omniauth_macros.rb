module OmniauthMacros
  def mock_vkontakte_auth_hash
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      'provider' => 'vkontakte',
      'uid' => '123456',
      'info' => {
        'name' => 'Tatyana',
        'last_name' => 'Shkuropatova',
        'nickname' => 'delosiliana',
        'phone' => '81111111111'
      }
    })
  end

  def mock_invalid_vkontakte_auth_hash
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
  end

  def mock_twitter_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '1234567',
      'info' => {
        'nickname' => 'delosiliana',
        'email' => 'twitter@test.com'
      }
    })
  end

  def mock_invalid_twitter_auth_hash
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end
end
