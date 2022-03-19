class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_posts, only: [:index, :create]
  # before_action :set_comments, only: [:index, :show, :create, :edit, :update]
  before_action :set_likes, only: [:index, :show, :create, :edit, :update]


  # all posts (filtered by user/users) - each post shows comments (limit 3)
  def index
    @post = current_user.posts.build
  end

  # one post with all comments
  def show
    # @like = Like.find_or_initialize_by(user_id: current_user.id)
    @like = Like.find_by(user_id: current_user.id)
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      redirect_back(fallback_location: root_path)
      flash[:notice] = "Your post was created."
    else
      flash[:notice] = @post.get_flash_errors
      redirect_back(fallback_location: root_path)
    end
  end
  
  def edit
  end

  def update
    @post.assign_attributes(post_params)
    if @post.save
      redirect_back(fallback_location: root_path)
      flash[:notice] = "Your post was updated."
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
    @posts = Post.all
  end

  def set_comments
    # @comments = %w[a b c]
    # @comments = Comment.all.limit(3)
  end
  
  def set_likes
    # @likes = %w[a b c d e f g h]
  end

end
