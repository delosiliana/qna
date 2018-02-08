require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:no_author) { create :user}
  let(:answer) { create(:answer, question: question, user: user) }

  describe '#author? method for question' do
    it 'return true if user author resource' do
      expect(user.author?(question)).to be true
    end

    it 'return false if user no author resource' do
      expect(no_author.author?(question)).to be false
    end
  end

  describe '#author? method for answer' do
    it 'return true if user author resource' do
      expect(user.author?(answer)).to be true
    end

    it 'return false if user no author resource' do
      expect(no_author.author?(answer)).to be false
    end
  end
end
