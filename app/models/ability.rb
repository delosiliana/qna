class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  protected

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can [:update, :destroy], [Question, Answer, Comment], { user_id: user.id }
    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      !user.author?(votable)
    end
    can :best, Answer, question: { user_id: user.id }
    can :destroy, [Attachment] do |attachment|
      user.author?(attachment.attachable)
    end
  end
end
