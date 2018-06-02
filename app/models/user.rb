class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:vkontakte, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments
  has_many :authorizations, dependent: :destroy

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    return unless auth.info && auth.info[:email]

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.save!
      user.create_authorization(auth)
    else
      user = User.new
    end
    user
  end

  def author?(resource)
    resource.user_id == id
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
