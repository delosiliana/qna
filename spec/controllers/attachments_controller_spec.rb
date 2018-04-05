require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  login_user
  let(:author_question) { create(:question, user: @user) }
  let(:author_answer) { create(:answer, question: author_question, user: @user) }
  let(:answer) { create(:answer) }
  let(:file) { File.open("#{Rails.root}/spec/spec_helper.rb") }

  describe 'Delete #destroy' do
    context 'Author can delete attachment' do
      it 'delete attachment from answer' do
        author_answer.attachments.create(file: file)
        expect { delete :destroy, params: {id: author_answer.attachments.last}, format: :js }.to change(Attachment, :count).by(-1)
      end
    end

    context 'No author delete attachment' do
      it 'Trying delete attachment from answer' do
        answer.attachments.create(file: file)
        expect { delete :destroy, params: { id: answer.attachments.last }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end


