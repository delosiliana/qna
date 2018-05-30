require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  let!(:user) { @user || create(:user) }
  let(:question) { create :question }
  let(:answer) { create :best_answer, question: question }
  let(:another) { create :answer, question: question }
  let(:object) { 'Answer' }

  it_behaves_like 'Votable Model'

  describe '#best!' do
    it 'set best answer' do
      another.best!
      another.reload

      expect(another).to be_best
    end
  end

  describe 'scope' do
    describe '.ordered' do
      it 'best answer be first' do
        another.best!
        expect(question.answers.ordered.first).to eq another
      end
    end
  end
end
