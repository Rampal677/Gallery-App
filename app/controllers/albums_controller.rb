class AlbumsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @q = Album.ransack(params[:q])
    @albums = @q.result.includes(:tags).where(publish: true ).page(params[:page])
  end

  def myalbum
    @publish_albums = Album.where(user_id: current_user.id, publish:true)
    @unpublish_albums = Album.where(user_id: current_user.id, publish:false)
  end

  def show
    @album = Album.find(params[:id])
  end

  def delete_image_attached
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_to  album_params, notice: "Image deleted"
  end

  def new
    @album = Album.new
  end
  def create
    @album = current_user.albums.new(album_params)
    if @album.save
      redirect_to @album
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @album = Album.find(params[:id])
  end
  def update
    @album = Album.find(params[:id])

    if @album.update(album_params)
      redirect_to @album
    else
      render :edit,status: :unprocessable_entity
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def album_params
    params.require(:album).permit(:name,:description, :price,:user_id,:publish,:cover, :tag_list,:tag_ids ,images: [],)
  end
  def if_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path
    end
  end
end
