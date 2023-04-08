class ImagesController < ApplicationController
  # skip_forgery_protection
  before_action :authenticate_user!

  # 画像のアップロード
  def upload_image
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:file],
      filename: params[:file].original_filename,
      content_type: params[:file].content_type
    )
    current_user.images.attach(blob) #アップロード画像をユーザーと紐付け
    render json: {location: url_for(blob), id: blob.id}, status: :ok
  end

  # アップロードした画像の削除
  def delete_image
    image = current_user.images.find_by(blob_id: params[:image_id])
    image.purge
  end

end
