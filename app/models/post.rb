class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    # attrs: :content, :user_id

    validates :content, presence: { message: "You must provide some content to post." }
    validates :user_id, presence: { message: "You must provide a user." }
    validate :check_user_updating
    before_validation :format_content

    
    # ################ helpers (instantiation & validation)  ####################
        def check_user_updating
            if self.persisted?
                errors.add(:user_id, "Can't change the user of a post.") if self.user_id_changed? 
            end
        end

    
    # ################ helpers (nested or associated models)  ####################
        # ######## working with User model
        def self.all_by_user(user)
            self.where(user: user)
        end
        
        def self.all_by_user_collection(users)
            Post.where(user: [users])
        end
end
