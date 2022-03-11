module ApplicationHelper

    def request_notification_count
        tag.sup @request_count.to_s
    end

    def profile_display_class(profile_size)
        "reg-top-bottom-padding" if profile_size == "small"
    end

    def profile_image_class(profile_size)
        css_class = "large-profile-image" if profile_size == "large"
        css_class = "medium-profile-image" if profile_size == "medium"
        css_class = "small-profile-image" if profile_size == "small"
        css_class
    end

    def profile_info_class(profile_size)
        "profile-list" if profile_size == "small"
    end

end
