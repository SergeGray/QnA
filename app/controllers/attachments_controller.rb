class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource class: ActiveStorage::Attachment

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge if current_user.author_of?(@attachment.record)
  end
end
