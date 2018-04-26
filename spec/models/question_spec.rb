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

  describe '#vote' do
    it 'votes count' do
      expect{ another_question.vote(user, 1) }.to change(Vote, :count).by 1
    end

    context 'create a vote with the desired parameters' do
      before { @vote = another_question.vote(user, -1) }

      it 'belongs to question' do
        expect(@vote.votable_id).to eq another_question.id
      end
      
      it 'has polymorphic association Question' do
        expect(@vote.votable_type).to eq 'Question'
      end

      it 'belongs to user' do
        expect(@vote.user_id).to eq user.id
      end

      it 'downvotes the count' do
        expect(@vote.count).to eq -1
      end
    end
  end

  describe '#vote?' do
    let!(:vote_up) { create(:vote, :up, user: user, votable: question) }

    it 'return true if user have the right to vote' do
      expect(question.vote?(user, 1)).to eq true
    end

    it 'return false if the user does not have the right to vote' do
      expect(another_question.vote?(user, 1)).to eq false
    end
  end
end
