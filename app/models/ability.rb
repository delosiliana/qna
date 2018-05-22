class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    load_aliases
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  protected

  def load_aliases
    alias_action :vote_up, :vote_down, to: :vote
    alias_action :update, :destroy, to: :action
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can :action, [Question, Answer, Comment], { user_id: user.id }
    can :vote, [Question, Answer] do |votable|
      !user.author?(votable)
    end
    can :best, Answer, question: { user_id: user.id }
    can :destroy, [Attachment] do |attachment|
      user.author?(attachment.attachable)
    end
    can :me, User, id: user.id
  end
end
