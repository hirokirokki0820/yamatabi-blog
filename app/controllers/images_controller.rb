class ImagesController < ApplicationController
  # skip_forgery_protection

  # 画像のアップロード
  def upload_image
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:file],
      filename: params[:file].original_filename,
      content_type: params[:file].content_type
    )
    # render json: blob
    render json: {location: url_for(blob), id: blob.id}, status: :ok
  end

  # アップロードした画像の削除
  def delete_image
    image = ActiveStorage::Blob.find_by_id(params[:image_id])
    image.purge
  end

    # メディア追加ボタンからアップロード
  # def upload_image_from_media
  #   @image_blob = create_blob(params[:file])
  #   render json: @image_blob
  # end

  private
  # def create_blob(file)
  #   ActiveStorage::Blob.create_and_upload!(
  #     io: file.open,
  #     filename: file.original_filename,
  #     content_type: file.content_type
  #   )
  # end
end
