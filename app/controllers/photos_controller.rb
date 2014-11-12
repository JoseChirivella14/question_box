class PhotosController < ApplicationController
  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      redirect_to questions_path
    else
      notice :error, status: 401
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
