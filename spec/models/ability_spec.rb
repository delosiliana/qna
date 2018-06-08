require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, user: user) }
    let(:no_author_question) { create(:question, user: other) }
    let(:answer) { create :answer, user: user, question: question }
    let(:no_author_answer) { create :answer, user: other, question: question }
    let(:author_question_attacment) { create :attachment, attachable: question }
    let(:no_author_question_attachment) { create :attachment, attachable: no_author_question }
    let(:author_answer_attacment) { create :attachment, attachable: answer }
    let(:no_author_answer_attachment) { create :attachment, attachable: no_author_answer }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, no_author_question, user: user }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, no_author_question, user: user }
      it { should be_able_to :vote_up, no_author_question, user: user }
      it { should_not be_able_to :vote_up, question, user: user }
      it { should be_able_to :vote_down, no_author_question, user: user }
      it { should_not be_able_to :vote_down, question, user: user }
      it { should be_able_to :destroy, author_question_attacment, user: user }
      it { should_not be_able_to :destroy, no_author_question_attachment, user: user }
    end

    context 'answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, no_author_answer }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, no_author_answer }
      it { should be_able_to :vote_up, no_author_answer }
      it { should_not be_able_to :vote_up, answer }
      it { should be_able_to :vote_down, no_author_answer }
      it { should_not be_able_to :vote_down, answer }
      it { should be_able_to :best, no_author_answer }
      it { should_not be_able_to :best, create(:answer, user: other, question: no_author_question ) }
      it { should be_able_to :destroy, author_answer_attacment }
      it { should_not be_able_to :destroy, no_author_answer_attachment }
    end

    context 'comment' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update, create(:comment, user: user), user: user }
      it { should_not be_able_to :update, create(:comment, user: other), user: user }
      it { should be_able_to :destroy, create(:comment, user: user), user: user }
      it { should_not be_able_to :destroy, create(:comment, user: other), user: user }
    end

    context 'subscription' do
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, Subscription }
    end
  end
end
