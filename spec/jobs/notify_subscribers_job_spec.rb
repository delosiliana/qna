require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'sends mail with answer to subscribers' do
    question.subscriptions.find_each do |subscription|
      expect(Mailer).to receive(:notify).with(subscription.user, asnwer).and_call_original
    end
    NotifySubscribersJob.perform_now(answer)
  end
end
