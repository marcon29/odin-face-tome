module ApplicationHelper

    def profile_display_klass(profile_size)
        if profile_size == "large" || profile_size == "medium"
            "add-bottom-border"
        else
            "reg-top-bottom-padding"
        end
    end

    def profile_image_class(profile_size)
        css_class = "large-profile-image" if profile_size == "large"
        css_class = "medium-profile-image" if profile_size == "medium"
        css_class = "small-profile-image" if profile_size == "small"
        css_class
    end

end
