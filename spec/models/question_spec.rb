require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:another_question) { create(:question) }

  context '.vote' do
    it 'votes count' do
      expect{ another_question.vote(user, 1) }.to change(Vote, :count).by 1
    end

    it 'create a vote with the desired parameters' do
      vote = another_question.vote(user, -1)
      expect(vote.votable_id).to eq another_question.id
      expect(vote.votable_type).to eq 'Question'
      expect(vote.user_id).to eq user.id
      expect(vote.count).to eq -1
    end
  end

  context '.vote?' do
    let!(:vote_up) { create(:vote, :up, user: user, votable: question) }

    it 'return true if user have the right to vote' do
      expect(question.vote?(user, 1)).to eq true
    end

    it 'return false if the user does not have the right to vote' do
      expect(another_question.vote?(user, 1)).to eq false
    end
  end
end
