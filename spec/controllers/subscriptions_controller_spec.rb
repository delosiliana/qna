require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { @user || create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:subscription) { create(:subscription, user: user, question: question) }

  describe 'POST#create' do
    login_user

    it 'assign subscription user' do
      expect { post :create, params: { question: question, user: @user }, format: :js }.to change(@user.subscriptions, :count).by(1)
    end

    it 'assign subscription to question' do
      expect { post :create, params: { question: question, user: @user }, format: :js }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    login_user
    let!(:unsubscription) { create(:subscription, user: @user, question: question) }

    it 'destroy subscription' do
      expect { delete :destroy, params: { question_id: question, id: unsubscription.id }, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end
