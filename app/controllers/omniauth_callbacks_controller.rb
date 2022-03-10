class OmniauthCallbacksController  < Devise::OmniauthCallbacksController
    # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
    # skip_before_action :verify_authenticity_token, only: :facebook
    # skip_before_action :verify_authenticity_token, only: :github


    # request.env["omniauth.auth"] provides: name, image, email, provider, uid, token
    def facebook
        @user = User.from_omniauth(request.env["omniauth.auth"])
        
        # sign_in_and_redirect @user
        
        if @user.persisted?
            sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
            set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
            redirect_to new_user_registration_url
        end
    end

    def github
        @user = User.from_omniauth(request.env["omniauth.auth"])
        binding.pry
        sign_in_and_redirect @user
    end

    def failure
        redirect_to root_path
    end

end