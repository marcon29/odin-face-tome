module ApplicationHelper

    def profile_display_class(profile_size)
        "reg-top-bottom-padding" if profile_size == "small"
    end

    def profile_image_class(profile_size)
        css_class = "large-profile-image" if profile_size == "large"
        css_class = "medium-profile-image" if profile_size == "medium"
        css_class = "small-profile-image" if profile_size == "small"
        css_class
    end

end
