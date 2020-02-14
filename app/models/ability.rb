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

    can :select, Answer do |answer|
      answer.question.user_id == @user.id 
    end

    can :vote, [Question, Answer] do |votable|
      votable.user_id != @user.id
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      attachment.record.user_id == @user.id
    end

    can :destroy, Link do |link|
      link.linkable.user_id == @user.id
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
