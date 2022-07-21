class AlbumsController < ApplicationController
  before_action :permission, only: [:destroy, :edit]
  after_action :if_login, only: [:edit,:update]
  def index
    @q = Album.ransack(params[:q])
    @albums = @q.result.includes(:tags).where(publish: true ).page(params[:page])
  end
  def myalbum
    @publish_albums = Album.where(user_id: current_user.id, publish:true)
    @unpublish_albums = Album.where(user_id: current_user.id, publish:false)
  end
  def show
    @albums = Album.find(params[:id])
  end
  def delete_image_attached
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_to  album_params, notice: "Image deleted"
  end
  def new
    @albums = Album.new
  end
  def create
    @albums = current_user.albums.new(album_params)
    # @albums = Album.new(album_params)
    if @albums.save
      redirect_to @albums
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    # if(@albums.user_id == current_user.id)
    @albums = Album.find(params[:id])
    # end
  end
  def update
    @albums = Album.find(params[:id])

    if @albums.update(album_params)
      redirect_to @albums
    else
        render :edit,status: :unprocessable_entity
    end
  end
  def destroy
    @albums = Album.find(params[:id])
    @albums.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def album_params
    params.require(:album).permit(:name,:description, :price,:user_id,:publish,:cover, :tag_list,:tag_ids ,images: [],)
  end

  def permission
    unless signed_in?
      if @albums.user_id == current_user.id?
        flash[:error] = "You must be logged in to access this section"
        redirect_to new_user_session_path
      end
    end
  end

  def if_login
    unless signed_in?
        flash[:error] = "You must be logged in to access this section"
        redirect_to root_path
      end
  end

end
