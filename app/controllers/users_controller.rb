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

    # ######## controls user uploaded profile image (loading and changing) #########
    if params[:user][:profile_image].present?
  # need to validate = set up other conditional for if .save
      
      current_user.assign_attributes(profile_image: params[:user][:profile_image])
      if current_user.save
        flash[:notice] = "Profile image update. Nice look!"
      end
    end

    # ######## controls use of Oauth image (if it exits)  #########
    if current_user.image_url.nil? || params[:user][:profile_image].present?
    # if current_user.image_url.nil? 
      current_user.update(oauth_default: false)
    elsif oauth_default_changed?
      current_user.update(oauth_default: params[:user][:oauth_default])
      if params[:user][:oauth_default].to_i == 1
        flash[:notice] = "Switched to using your Facebook profile picture."
      elsif current_user.profile_image.present?
        flash[:notice] = "Switched to #{current_user.profile_image.filename} as your profile picture."
      else 
        flash[:notice] = "Switched to using the site default image. How generic!"
      end
    end

    # ######## controls postioning of user upload image (if it exits)  #########
    blob = current_user.profile_image.blob

    if current_user.profile_image.attached? && profile_image_params[:attachment].present?
      blob.assign_attributes(profile_image_params[:attachment])
      if blob.save && flash[:notice].nil?
        flash[:notice] = "Image positioning saved."
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def delete_profile_image
    attachment = ActiveStorage::Attachment.find_by(record_id: current_user.id)
    attachment.purge unless attachment.nil?
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
