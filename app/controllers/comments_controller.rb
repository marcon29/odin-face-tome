class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user_to_change, only: [:edit, :update, :destroy]

  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      flash[:notice] = "Your comment was added."
      redirect post_path(@comment.post) if !request.referrer
      redirect_to "#{request.referrer}#post-#{@comment.post.id}"
    else
      flash[:notice] = @comment.get_flash_errors
      redirect root_path if !request.referrer
      redirect_to "#{request.referrer}#post-#{@comment.post.id}"
    end
  end

  def edit
  end

  def update
    referrer = params[:comment][:prev_referrer]

    @comment.assign_attributes(comment_params)
    if @comment.save
      flash[:notice] = "Your comment was updated."
      redirect post_path(@comment.post) if !request.referrer
      redirect_to "#{referrer}#post-#{@comment.post.id}"
    else
      flash[:notice] = @comment.get_flash_errors
      redirect root_path if !request.referrer
      redirect_to "#{referrer}#post-#{@comment.post.id}"
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Your comment was deleted."
    redirect post_path(@comment.post) if !request.referrer
    redirect_to "#{request.referrer}#post-#{@comment.post.id}"
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :content, :user_id, :post_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
