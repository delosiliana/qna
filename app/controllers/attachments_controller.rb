class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author?(@attachment.attachable)
      @attachment.destroy
      flash[:notice] = 'Attachment deleted'
    else
      flash[:notice] = 'You can not delete attachment'
    end
  end
end
