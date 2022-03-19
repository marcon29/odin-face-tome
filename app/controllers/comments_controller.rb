class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      flash[:notice] = "Your comment was added."
      # redirect_back(fallback_location: root_path)
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
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :content, :user_id, :post_id)
  end
end
