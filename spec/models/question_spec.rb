require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:another) { create(:question) }
  let(:object) { 'Question' }

  it_behaves_like 'Votable Model'
end
