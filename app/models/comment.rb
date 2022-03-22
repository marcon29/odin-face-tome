class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :post

    # attrs: :content, :user_id, post_id

    validates :content, presence: { message: "You must provide some content to your comment." }
    validates :user_id, presence: { message: "You must provide a user." }
    validates :post_id, presence: { message: "You must provide a post." }
    validate :check_user_and_post_updating
    before_validation :format_content
    
    
    # ################ helpers (data control)  ####################
    def self.display_limit
        2
    end
end
