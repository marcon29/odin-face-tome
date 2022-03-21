class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_to_change, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_posts, only: [:index, :create]

  def index
    @post = current_user.posts.build
  end

  def show
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      flash[:notice] = "Your post was created."
      redirect_back(fallback_location: root_path)
    else
      flash[:failure] = @post.get_flash_errors
      redirect_back(fallback_location: root_path)
    end
  end
  
  def edit
  end

  def update
    referrer = params[:post][:prev_referrer]

    @post.assign_attributes(post_params)
    if @post.save
      flash[:notice] = "Your post was updated."
      redirect post_path(@post) if !request.referrer
      redirect_to "#{referrer}#post-#{@post.id}"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Your post was deleted."
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:id, :content, :user_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_posts
    @posts = current_user.timeline_posts.order(created_at: :desc)
  end
end
