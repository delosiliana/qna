require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  login_user

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: @user) }
  let!(:comment) { create(:comment, commentable: question, user: @user) }

  describe 'POST #create' do

    context 'valid attributes for comment' do
      it ' belongs in user' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js }
        expect(question.comments.last.user_id).to eq @user.id
      end

      it 'saves new comment' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js } }.to change(question.comments, :count).by(1)
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js} }.to change(answer.comments, :count).by(1)
      end

      it ' re-render create views' do
        post :create, params: { answer_id: answer, comment: attributes_for(:comment), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'invalid attributes' do
      it 'doesnt save comment' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), format: :js } }.to_not change(Comment, :count)
      end

      it 're-render create view invalid params' do
        post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'author  tries to delete comment' do
      it 'delete comment' do
        expect { delete :destroy, params: { id: comment, format: :js} }.to change(Comment, :count).by(-1)
      end

      it 'render question' do
        delete :destroy, params: { id: comment, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context ' User no author to delete another user comment' do
      let!(:no_author) { create(:user) }
      let!(:comment_another) { create(:comment, commentable: answer, user: no_author) }

      it 'doesnt delete answer' do
        expect { delete :destroy, params: { id: comment_another, format: :js} }.to_not change(Comment, :count)
      end

      it 'render question show views' do
        delete :destroy, params: { id: comment_another, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'patch #update' do
    it 'assigns the requested comment to comment' do
      patch :update, params: { id: comment, question_id: question, comment: attributes_for(:comment), format: :js }
      expect(assigns(:comment)).to eq comment
    end

    it 'change attributes comment' do
      patch :update, params: { id: comment, question_id: question, comment: { body: 'comment'}, format: :js }
      comment.reload
      expect(comment.body).to eq 'comment'
    end

    it 'assign commentable' do
      patch :update, params: { id: comment, question_id: comment, comment: { body: 'comment' }, format: :js }
      expect(assigns(:commentable)).to eq question
    end

    it 'rerenders the template' do
      patch :update, params: { id: comment, question_id: question, comment: attributes_for(:comment), format: :js }
      expect(response).to render_template :update
    end
  end
end
