module ApplicationHelper

    # ################ Post/Comment/Like Helpers  ####################
   

    # ################ User/Registration/Session/Friend Helpers  ####################
    def request_notification_count
        tag.sup @request_count.to_s
    end

    def profile_display_classes(location)
        string = "profile-#{location.dasherize}"
        string = ("profile-display" + " " + string) if location!="left_sidebar"
        string
    end

    def profile_info_classes(location)
        if location == "post" || location == "comment"
            "profile-info-post-comment"
        else
            "profile-info"
        end
    end

    def profile_image_classes(location)
        if location == "header"
            css_class = "large-profile-image"
        elsif location == "left_sidebar"
            css_class = "medium-profile-image"
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

    def get_user_stats(stat_type)
        user_stat = current_user.friends.count if stat_type == "friends"
        user_stat ||= current_user.posts.count if stat_type == "posts"
        user_stat ||= current_user.comments.count if stat_type == "comments"
        format_user_stat(user_stat)
    end

    def format_user_stat(user_stat)
        if user_stat >= 10000 && user_stat < 100000
            display = (user_stat.to_f/1000).truncate(2).to_s + "k"
        elsif user_stat >= 100000 && user_stat < 1000000
            display = (user_stat.to_f/1000).truncate(1).to_s + "k"
        elsif user_stat >=1000000
            display = (user_stat.to_f/1000000).truncate(3).to_s + "m"
        end
        display ? display : user_stat
    end
end
