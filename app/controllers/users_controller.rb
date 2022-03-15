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
    @blob = current_user.profile_image.blob
    
    # ######## controls displaying Oauth image
    if oauth_default_changed?
      current_user.assign_attributes(oauth_default: params[:user][:oauth_default])
      get_flash_notice(:oauth)
    end
    
    # ######## controls upload
    if params[:user][:profile_image].present?
      current_user.profile_image.attach(params[:user][:profile_image])
      get_flash_notice(:image)
    end

    # ######## controls upload postioning
    if profile_image_positioning_changed? && ok_to_update_blob?
      @blob.assign_attributes(profile_image_params[:attachment])
      get_flash_notice(:blob)
    end

    # ######## normal save/redirect
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

  def profile_image_positioning_changed?
    check = false
    params[:user][:attachment].each do |attr, value|
      # binding.pry
      if check == false
        @blob.send(attr).blank? ? blob_val = nil : blob_val = @blob.send(attr)
        value.blank? ? param_val = nil : param_val = value
        check = true if blob_val != param_val
      end
    end
    check
    # binding.pry
  end

  def ok_to_update_blob?
    current_user.errors.messages[:profile_image].empty? && current_user.profile_image.attached? && profile_image_params[:attachment].present?
  end

  def get_flash_notice(notice_type)
    if notice_type == :oauth
      if params[:user][:oauth_default].to_i == 1
        flash[:notice] = "Switched to using your Facebook profile picture."
      elsif current_user.profile_image.present?
        flash[:notice] = "Switched to #{current_user.profile_image.filename} as your profile picture."
      else 
        flash[:notice] = "Switched to using the site default image. How generic!"
      end
    elsif notice_type == :image
      if current_user.valid?
        flash[:notice] = "Profile image updated. Nice look!"
      end
    elsif notice_type == :blob
      if @blob.save && flash[:notice].nil?
        flash[:notice] = "Image positioning saved."
      end
    end
  end

end
