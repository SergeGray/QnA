# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if @user
      @user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all

    can :result, :search
  end

  def user_abilities
    guest_abilities

    can :me, User
    can :create, [Question, Answer, Comment, Subscription]
    can %i[update destroy], [Question, Answer], user_id: @user.id
    can :destroy, ActiveStorage::Attachment, record: { user_id: @user.id }
    can :destroy, Link, linkable: { user_id: @user.id }
    can :destroy, Subscription, user_id: @user.id
    can :select, Answer, best: false, question: { user_id: @user.id }

    can :vote, [Question, Answer] do |votable|
      votable.user_id != @user.id
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
