class LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    like = current_user.likes.build(like_params)

    if like.save
      redirect post_path(like.post) if !request.referrer
      redirect_to "#{request.referrer}#post-#{like.post.id}"
    else
      redirect root_path if !request.referrer
      redirect_to "#{request.referrer}#post-#{like.post.id}"
    end
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy
    redirect_to "#{request.referrer}#post-#{like.post.id}"
  end

  private

  def like_params
    params.require(:like).permit(:id, :user_id, :post_id)
  end
end