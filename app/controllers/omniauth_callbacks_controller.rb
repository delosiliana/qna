class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vkontakte
    define_oauth_from(:vkontakte)
  end

  def twitter
    define_oauth_from(:twitter)
  end


  private

  def define_oauth_from(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
    end
  end
end
