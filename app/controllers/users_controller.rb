class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # weird to simply make one instance variable equal to another
    # but leaving in case I figure out how ot make all non-contacted users
    # different from suggested ones (which they should be)
    @users = @suggested_friends.limit(20)
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit_profile_image
  end 

  def update_profile_image
    # ######## controls use of Oauth image (if it exits)  #########
    if oauth_default_changed?
      current_user.assign_attributes(oauth_default: params[:user][:oauth_default])
      if params[:user][:oauth_default].to_i == 1
        flash[:notice] = "Switched to using your Facebook profile picture."
      elsif current_user.profile_image.present?
        flash[:notice] = "Switched to #{current_user.profile_image.filename} as your profile picture."
      else 
        flash[:notice] = "Switched to using the site default image. How generic!"
      end
    end

    
    # ######## controls user uploaded profile image (loading and changing) #########
    if params[:user][:profile_image].present?
      current_user.profile_image.attach(params[:user][:profile_image])
      if current_user.valid?
        flash[:notice] = "Profile image update. Nice look!"
      end
    end

    # ######## controls postioning of user upload image (if it exits)  #########
    if current_user.errors.messages[:profile_image].empty? && current_user.profile_image.attached? && profile_image_params[:attachment].present?
      blob = current_user.profile_image.blob
      blob.assign_attributes(profile_image_params[:attachment])
      if blob.save && flash[:notice].nil?
        flash[:notice] = "Image positioning saved."
      end
    end

    if current_user.save
      redirect_to edit_profile_image_user_path
    else
      flash.delete(:notice)
      render :edit_profile_image
    end

    
  end

  def delete_profile_image
    attachment = ActiveStorage::Attachment.find_by(record_id: current_user.id)
    attachment.purge unless attachment.nil?
    flash[:notice] = "#{attachment.blob.filename} was deleted."
    redirect_back(fallback_location: root_path)
  end

  private

  def profile_image_params
    params.require(:user).permit(:oauth_default, attachment: [:fit, :position, :horiz_pos, :vert_pos])
  end

  def oauth_default_changed?
    params[:user][:oauth_default].to_i == 1 ? check = true : check = false
    current_user.oauth_default != check
  end

end
