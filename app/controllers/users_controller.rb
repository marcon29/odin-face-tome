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



  # ######## shit worked here - with this commented out #######
  # def edit_profile_image
  #   search_id = current_user.profile_image.id
  #   @profile_image = ActiveStorage::Attachment.find_or_create_by(id: search_id)
  #   @blob = @profile_image.blob

  #   @direct = current_user.profile_image.blob
  # end 

  # ######### fixes (in name only - or FINOs) ##################
  # def edit_profile_image
    # search_id = current_user.profile_image.id
    # @profile_image = ActiveStorage::Attachment.find_or_create_by(id: search_id)

    # @profile_image = ActiveStorage::Attachment.find_or_create_by(record_id: current_user.id)

    # @profile_image = current_user.profile_image
    # @profile_image = current_user.build_profile_image_attachment if current_user.profile_image.id.nil?
    # @profile_image = ActiveStorage::Attachment.find_or_create_by(record_id: current_user.id) if current_user.profile_image.id.nil?
    # @profile_image = current_user.profile_image.attach(profile_image_blob) if current_user.profile_image.id.nil?

    # @blob = @image.blob

    # @direct = current_user.profile_image.blob
  # end 

  # #########@###################
  # #########@###################
  # #########@###################

  def update_profile_image
    # blob = current_user.profile_image.blob

    # ######## controls user uploaded profile image (loading and changing) #########
    if params[:user][:profile_image].present?
  # need to validate = set up other conditional for if .save
      
      current_user.assign_attributes(profile_image: params[:user][:profile_image])
      if current_user.save
        flash[:notice] = "Profile image update. Nice look!"
      end
    end

    # ######## controls use of Oauth image (if it exits)  #########
    if current_user.image_url.nil?
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
    
    if current_user.profile_image.attached?
      blob.assign_attributes(profile_image_params[:attachment])
      if blob.save && flash[:notice].nil?
        flash[:notice] = "Image positioning saved."
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def delete_profile_image
    # @profile_image = ActiveStorage::Attachment.find_or_create_by(record_id: current_user.id)


    binding.pry
    blob = current_user.profile_image.blob
    attachment = ActiveStorage::Attachment.find_or_create_by(id: search_id)

    redirect_back(fallback_location: root_path)
  end

  private

  def profile_image_params
    params.require(:user).permit(:oauth_default, attachment: [:fit, :position, :horiz_pos, :vert_pos])
    # params.require(:user).permit(:fit, :position, :horiz_pos, :vert_pos)
    # params.require(:image_profile).permit(:fit, :position, :horiz_pos, :vert_pos)

    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username, :profile_image, :oauth_default, :fit, :position, :horiz_pos, :vert_pos])
    # devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username, :profile_image, :oauth_default, :fit, :position, :horiz_pos, :vert_pos])
  end

  def oauth_default_changed?
    params[:user][:oauth_default].to_i == 1 ? check = true : check = false
    current_user.oauth_default != check
  end

end
