class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_oauth_from_provider, only: [:vkontakte, :twitter]
  before_action :make_oauth, only: [:vkontakte, :twitter]

  def vkontakte
  end

  def twitter
  end

  def register
    User.register_for_oauth(params[:email], params[:provider], params[:uid])
    redirect_to new_user_session_path, notice: 'You must confirm email to continue'
  end

  private

  def make_oauth
    @provider_auth = request.env['omniauth.auth'].provider.capitalize
  end

  def sign_in_oauth_from_provider
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @provider_auth) if is_navigational_format?
    else
      @auth_info = request.env['omniauth.auth']
      render 'omniauth_callbacks/add_email'
    end
  end
end
