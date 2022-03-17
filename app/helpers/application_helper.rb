module ApplicationHelper

    # ################ Post/Comment/Like Helpers  ####################



    # ################ User/Registration/Session/Friend Helpers  ####################
    def request_notification_count
        tag.sup @request_count.to_s
    end

    def profile_image_classes(location)
        # css_class = "large-profile-image" if location == "header"
        # css_class = "small-profile-image" if (location == "right_sidebar" || location == "main" )
        # css_class


        if location == "header"
            css_class = "large-profile-image"
        else
            css_class = "small-profile-image"
        end
        css_class
    end

    def image_positioning_styles(user)
        collection = user.collect_image_positioning_data

        if collection.nil?
            classes = ""
        else
            fitting = "object-fit: #{collection[:obj_fit]};" if collection[:obj_fit]
            if collection[:obj_pos].present?
                position = "object-position: #{collection[:obj_pos]};"
            else
                collection[:obj_horiz] = 0 if collection[:obj_horiz].blank?
                collection[:obj_vert] = 0 if collection[:obj_vert].blank?
                position = "object-position: #{collection[:obj_horiz]}px #{collection[:obj_vert]}px;"
            end
            classes = fitting + " " + position
        end
    end
    
    def get_image_mgr_current_display
        label = tag.p class: "remove-bottom-margin" do
            tag.b "Current display image: "
        end

        if current_user.image_url && current_user.oauth_default
            name = tag.p "Facebook Profile Image", class: "short-top-bottom-margins"
        elsif !current_user.profile_image.id.nil?
            name = tag.p current_user.profile_image.filename, class: "short-top-bottom-margins"
        else
            name = tag.p User.fallback_profile_image[:display_name], class: "short-top-bottom-margins"
        end

        concat label + name
    end

    def get_profile_header_user_info(user)
        concat tag.p "@#{user.username}", class: "short-top-bottom-margins"
        if user == current_user || user.friend?(current_user)
            concat tag.p user.email, class: "short-top-bottom-margins" 
        end
    end
end
