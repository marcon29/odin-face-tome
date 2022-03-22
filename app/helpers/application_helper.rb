module ApplicationHelper
    
    # ################ General Helpers  ####################
    
    def get_form_text(item, attr, action=nil)
        form_name = item.object_name.to_sym
        attr = attr.to_sym
        action ? action = action.to_sym : action = action_name.to_sym
        
        form_text = {
            comment: {
                header:  { edit: "Edit Your Comment" }, 
                content: { placeholder: "Add your comment..." }, 
                submit:  { index: "Comment", show: "Comment", edit: "Update Comment" }
            },
            post: {
                header: { 
                    index: "What's on your mind, #{current_user.first_name}?",  
                    show: "What's on your mind, #{current_user.first_name}?",  
                    edit: "Edit Your Post" }, 
                content: { placeholder: "Share your thoughts..." }
            }
        }

        # binding.pry
        form_text[form_name][attr][action]
    end

    def display_count(collection, text)
        display_text = collection.count == 1 ? text.singularize : text
        "#{collection.count} #{display_text}"
    end

    # ################ Post/Comment/Like Helpers  ####################
    def pass_previous_referrer(item, action)
        if action_name == action && request.referrer.present?
            item.hidden_field :prev_referrer, value: request.referrer
        end
    end

    def show_see_all_comments?(post)
        (controller_name != "posts" || action_name != "show") && post.comments.count > Comment.display_limit
    end

    def get_post_comment_control_path(item, action)
        model = item.class.name.underscore.pluralize
        if action.downcase == "edit"
            path = "/#{model}/#{item.id}/#{action.downcase}"
        else
            path = "/#{model}/#{item.id}"
        end
        path
    end

    # ################ User/Registration/Session/Friend Helpers  ####################
    def request_notification_count
        tag.sup @request_count.to_s
    end

    def profile_display_classes(location)
        string = "profile-display"
        string << " flex-container" if location!="left_sidebar" && location != "header"
        string
    end

    def profile_user_classes(location)
        string = "profile-user"
        string << " flex-container" if location == "post" || location == "comment"
        string
    end

    # def profile_display_classes(location)
    #     string = "profile-#{location.dasherize}"
    #     string = ("profile-display" + " " + string) if location!="left_sidebar"
    #     string
    # end

    # def profile_info_classes(location)
    #     if location == "post" || location == "comment"
    #         "profile-info-post-comment"
    #     else
    #         "profile-info"
    #     end
    # end

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

    def get_formatted_name(user, location)
        if location == "header"
            tag.h1 user.full_name
        elsif location == "left_sidebar"
            tag.h4 link_to user.full_name, user_path(user)
        else
            tag.p link_to user.full_name, user_path(user)
        end 
        
        # styles: h4 (short top bottom), h1 (0 margin)
    end

    def display_username?(location)
        user_show_header?(location) || location == "post" || location == "comment"
        
        # styles: p (short top bottom)
    end

    def display_email?(location, user)
        user_show_header?(location) && ( user == current_user || user.friend?(current_user) )

        # styles: p (short top bottom)
    end

    def display_stats?(location)
        user_show_header?(location) || location == "left_sidebar"
    end

    def user_show_header?(location)
        location == "header" && action_name == "show"
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

    # def get_profile_header_user_info(user)
    #     concat tag.p "@#{user.username}", class: "short-top-bottom-margins"
    #     if user == current_user || user.friend?(current_user)
    #         concat tag.p (mail_to user.email, user.email), class: "short-top-bottom-margins" 
    #     end
    # end

    def get_user_stats(stat_type, user)
        user_stat = user.friends.count if stat_type == "friends"
        user_stat ||= user.posts.count if stat_type == "posts"
        user_stat ||= user.comments.count if stat_type == "comments"
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
