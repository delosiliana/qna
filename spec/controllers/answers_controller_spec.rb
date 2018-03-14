require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) {create(:answer, user: user, question: question) }
  let(:invalid_params) { { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }

  describe 'POST #create' do
    login_user
    let(:params) { { answer: attributes_for(:answer), question_id: question, format: :js } }

    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'the answer belongs to user' do
        expect { post :create, params: params }.to change(@user.answers, :count).by(1)
      end

      it 'render template create' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end

    context 'with no valid attributes' do
      it 'doesnt save the answer' do
        expect { post :create, params: invalid_params }.to_not change(Answer, :count)
      end

      it 'render template create' do
        post :create, params: invalid_params
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    login_user
    let!(:answer) { create(:answer, question: question) }
    let!(:answer_author) { create(:answer, question: question, user: @user) }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer_author, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer_author
    end

    it 'assigns  the question' do
      patch :update, params: { id: answer_author, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer_author, answer: { body: 'new body' },question_id: question, format: :js }
      answer_author.reload
      expect(answer_author.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer_author, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    login_user

    let!(:answer) { create(:answer, question: question) }
    let!(:author_answer) { create(:answer, question: question, user: @user) }

    context 'author delete answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: author_answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: author_answer, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'no author  tries to delete answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end
    end
  end
end
