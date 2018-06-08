require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:users) { create_list(:user, 4) }

  it 'sends mail with answer to subscribers' do
    users.each { |user| user.subscriptions.create(question: question) }

    question.subscriptions.find_each do |subscription|
      expect(QuestionsMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end
    NotifySubscribersJob.perform_now(answer)
  end
end
