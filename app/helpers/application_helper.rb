module ApplicationHelper

    def request_notification_count
        tag.sup @request_count.to_s
    end

    def profile_display_class(profile_size)
        "reg-top-bottom-padding" if profile_size == "small"
    end

    def profile_info_class(profile_size)
        "profile-list" if profile_size == "small"
    end

    def profile_image_classes(profile_size)
        css_class = "large-profile-image" if profile_size == "large"
        css_class = "medium-profile-image" if profile_size == "medium"
        css_class = "small-profile-image" if profile_size == "small"
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
 


end
