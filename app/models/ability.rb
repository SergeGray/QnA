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
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], user_id: @user.id
    can :destroy, ActiveStorage::Attachment, record: { user_id: @user.id }
    can :destroy, Link, linkable: { user_id: @user.id }
    can :select, Answer, best: false, question: { user_id: @user.id }

    can :upvote, [Question, Answer] do |votable|
      votable.user_id != @user.id && votable.vote_value(@user) <= 0
    end

    can :downvote, [Question, Answer] do |votable|
      votable.user_id != @user.id && votable.vote_value(@user) >= 0
    end

    can :cancel, [Question, Answer] do |votable|
      votable.user_id != @user.id && votable.vote_value(@user) != 0
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
