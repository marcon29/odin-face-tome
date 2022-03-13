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
    search_id = current_user.profile_image.id
    @image = ActiveStorage::Attachment.find_or_create_by(id: search_id)
    @blob = @image.blob

    @direct = current_user.profile_image.blob
  end

  # fit: contain, cover, fill, none
  # vert_pos: XXX
  # horiz_pos: XXX
  # position: bottom, center, left, right, top, none (unset)


  def update_profile_image
    blob = current_user.profile_image.blob

    binding.pry
    
    current_user.update(oauth_default: params[:user][:oauth_default])
    current_user.update(profile_image: params[:user][:profile_image]) unless params[:user][:profile_image].nil?
    blob.update(profile_image_params[:attachment])
    
    redirect_back(fallback_location: root_path)
  end

  def delete_profile_image
  end

  def profile_image_params
    params.require(:user).permit(:oauth_default, attachment: [:fit, :position, :horiz_pos, :vert_pos])
    # params.require(:user).permit(:fit, :position, :horiz_pos, :vert_pos)
    # params.require(:image_profile).permit(:fit, :position, :horiz_pos, :vert_pos)

    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username, :profile_image, :oauth_default, :fit, :position, :horiz_pos, :vert_pos])
    # devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username, :profile_image, :oauth_default, :fit, :position, :horiz_pos, :vert_pos])
  end

  # adjusted_params
  

  # params[:user]= #<ActionController::Parameters {
  #   "profile_image"=>#<ActionDispatch::Http::UploadedFile:0x00007fffe061fa70 
  #     @tempfile=#<Tempfile:/tmp/RackMultipart20220312-1686-oblstn.jpg>, 
  #     @original_filename="zeke.jpg", 
  #     @content_type="image/jpeg", 
  #     @headers="
  #       Content-Disposition: form-data; 
  #       name=\"user[profile_image]\"; 
  #       filename=\"zeke.jpg\"\r\n
  #       Content-Type: image/jpeg\r\n
  #     "
  #   >, 
  #   "oauth_default"=>"0", 
  #   "fit"=>"cover", 
  #   "position"=>"bottom", 
  #   "horiz_pos"=>"", 
  #   "vert_pos"=>""
  # } permitted: false>

  # params[:user][:profile_image] = #<ActionDispatch::Http::UploadedFile:0x00007fffe061fa70 
  #   @tempfile=#<Tempfile:/tmp/RackMultipart20220312-1686-oblstn.jpg>, 
  #   @original_filename="zeke.jpg", 
  #   @content_type="image/jpeg", 
  #   @headers="Content-Disposition: form-data; 
  #     name=\"user[profile_image]\"; 
  #     filename=\"zeke.jpg\"\r\n
  #     Content-Type: image/jpeg\r\n"
  #   >


end
