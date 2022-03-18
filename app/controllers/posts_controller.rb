class PostsController < ApplicationController
  before_action :authenticate_user!

  # all posts (filtered by user/users) - each post shows comments (limit 3)
  def index
    @post = current_user.posts.build

    # placeholde values to get views to display correctly
        # replace these in other actions also
    @posts = Post.all
    @likes = %w[a b c d e f g h]
    @comments = %w[a b c]
  end

  # one post with all comments
  def show
    @post = Post.find(params[:id])

    # placeholde values to get views to display correctly
    @likes = %w[a b c d e f g h]
    @comments = %w[a b c]
  end
  
  def create
    @post = current_user.posts.build(post_params)

    # placeholde values to get views to display correctly
    @posts = Post.all
    @likes = %w[a b c d e f g h]
    @comments = %w[a b c]

    if @post.save
      redirect_back(fallback_location: root_path)
      flash[:notice] = "Your post was created."
    else
      render "posts/index"
    end
  end

  # not needed (partial only in feed)?
  def edit
    @post = Post.find(params[:id])

    # placeholde values to get views to display correctly
    @likes = %w[a b c d e f g h]
    @comments = %w[a b c]
  end

  def update
    @post = Post.find(params[:id])

    # placeholde values to get views to display correctly
    @likes = %w[a b c d e f g h]
    @comments = %w[a b c]

    @post.assign_attributes(post_params)
    if @post.save
      redirect_back(fallback_location: root_path)
      flash[:notice] = "Your post was updated."
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "Your post was deleted."
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(:id, :content, :user_id)
  end


end
