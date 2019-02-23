module ProfileDisplay

    extend ActiveSupport::Concern

    def profile_display
        if user_signed_in?
            @p_user = Profile.find_by(user_id: current_user.id)
        end
    end
end