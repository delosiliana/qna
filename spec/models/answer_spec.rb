require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  let(:question) { create :question }
  let(:answer) { create :best_answer, question: question }
  let(:another_answer) { create :answer, question: question }
  let!(:user) {create(:user) }

  describe '#best!' do
    it 'set best answer' do
      another_answer.best!
      another_answer.reload

      expect(another_answer).to be_best
    end
  end

  describe 'scope' do
    describe '.ordered' do
      it 'best answer be first' do
        another_answer.best!
        expect(question.answers.ordered.first).to eq another_answer
      end
    end
  end

  describe '#vote' do
    it 'change votes count' do
      expect{ another_answer.vote(user, -1) }.to change(Vote, :count).by 1
    end

    context 'created vote have correct params' do
      before { @vote = another_answer.vote(user, -1) }

      it 'belongs to answer' do
        expect(@vote.votable).to eq another_answer
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
    let!(:vote_up) { create(:vote, :up, user: user, votable: answer) }

    it 'return true if user have the right to vote' do
      expect(answer.vote?(user, 1)).to eq true
    end

    it 'return false if the user does not have the right to vote' do
      expect(another_answer.vote?(user, 1)).to eq false
    end
  end
end
