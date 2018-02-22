require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) {create(:answer, user: user, question: question) }
  let(:invalid_params) { { answer: attributes_for(:invalid_answer), question_id: question } }

  describe 'POST #create' do
    login_user
    let(:params) { { answer: attributes_for(:answer), question_id: question}}

    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'the answer belongs to user' do
        expect { post :create, params: params }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: params
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with no valid attributes' do
      it 'doesnt save the answer' do
        expect { post :create, params: invalid_params }.to_not change(Answer, :count)
      end

      it 'rerenders new view' do
        post :create, params: invalid_params
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    let!(:answer) { create(:answer, question: question) }
    let!(:author_answer) { create(:answer, question: question, user: @user) }

    context 'author delete answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: author_answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: author_answer }

        expect(response).to redirect_to author_answer.question
      end
    end

    context 'no author  tries to delete answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer} }.to_not change(Answer, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: author_answer }

        expect(response).to redirect_to answer.question
      end
    end
  end
end
