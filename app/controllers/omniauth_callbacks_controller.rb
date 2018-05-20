class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_oauth_from_provider, only: [:vkontakte, :twitter, :register]
  skip_authorization_check

  def vkontakte
  end

  def twitter
  end

  def register
    session[:auth] = nil
  end

  private

  def sign_in_oauth_from_provider
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      set_flash_message(:notice, :error, kind: auth.provider.capitalize) if is_navigational_format?
      flash[:notice] = 'Please enter email to complete your registration'
      session[:auth] = { uid: auth.uid, provider: auth.provider }
      render 'omniauth_callbacks/add_email', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params_auth)
  end

  def params_auth
    session[:auth] ? params[:auth].merge(session[:auth]) : params[:auth]
  end
end
