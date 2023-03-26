class ImagesController < ApplicationController
  skip_forgery_protection
  def upload_images
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:file],
      filename: params[:file].original_filename,
      content_type: params[:file].content_type
    )

    render json: {location: url_for(blob)}, status: :ok
     #, content_type: "text/html"
  end
end
