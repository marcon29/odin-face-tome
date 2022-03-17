class PostsController < ApplicationController
  before_action :authenticate_user!

  # all posts (filtered by user/users) - each post shows comments (limit 3)
  def index


    # placeholde values to get views to display correctly
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

  # not needed (partial only in feed)?
  # def new
  # end

  def create
  end

  # not needed (partial only in feed)?
  # def edit
  # end

  def update
  end

  def destroy
  end
end
