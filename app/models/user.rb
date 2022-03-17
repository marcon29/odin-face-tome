class User < ApplicationRecord
    # Others available Devise modules: :confirmable, :lockable, :timeoutable, :trackable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
    devise :omniauthable, omniauth_providers: %i[facebook]

    has_many :sent_friendship_requests, foreign_key: "request_sender_id", class_name: "Friend"
    has_many :received_friendship_requests, foreign_key: "request_receiver_id", class_name: "Friend"
    # has_many :posts, :comments, :likes

    has_one_attached :profile_image

    # User Model Attrs
        # reg attrs: :first_name, :last_name, :username, :email, :oauth_default
        # devise attrs: :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
        # oauth attrs: :provider, :uid, :image_url
    # Active Storage Blob Attrs
        # profile_image attrs: :fit, :position, :horiz_pos, :vert_pos

    validates :first_name, presence: { message: "You must provide your first name." }
    validates :last_name, presence: { message: "You must provide your last name." }
    validates :username, 
        presence: { message: "You must provide a username." }, 
        uniqueness: { case_sensitive: false, message: "That username is already used." }, 
        format: { with: /\A\w+\z/, message: "Username can only use letters and numbers without spaces." }
    validates :oauth_default, inclusion: { in: [true, false], message: "You must designate when to use your Facebook profile image." } 
    validates :email, format: { with: /\A\S+@\w+\.[a-zA-Z]{2,3}\z/, message: "Email doesn't look valid. Please use another." }
    validate :check_profile_image_content_type
    validate :set_oauth_default_upon_creation, on: :create
    before_validation :format_names, :format_username, :format_email
    after_validation :set_oauth_default


    # ################ helpers (callbacks & control flow)  ####################
        # something here
        

    # ################ helpers (instantiation & validation)  ####################
        # auth arg will be the data hash from provider
        def self.from_omniauth(auth)
            user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
                user.email = auth.info.email
                user.password = Devise.friendly_token[0,20]
                user.first_name = auth.info.name.split(" ").first
                user.last_name = auth.info.name.split(" ").last
                user.username = auth.info.name.gsub(" ","").downcase
                user.image_url = auth.info.image
            end

            if !user.persisted?
                RegistrationMailer.welcome_email(@user).deliver_now if user.save
            end
            user
        end

        def check_profile_image_content_type
            if self.profile_image.attached?
                ok_file_types = ["image/jpeg", "image/png"]
                if !ok_file_types.include?(self.profile_image.content_type)
                    errors.add(:profile_image, "You may only upload .jpeg or .png files.")
                end
            end
        end

        def set_oauth_default
            if self.image_url.blank? || (self.profile_image.changes && self.profile_image.changes[:record_id].present?)
                self.oauth_default = false
            end
        end

        def set_oauth_default_upon_creation
            self.oauth_default = false
            self.oauth_default = true if self.image_url.present?
        end


    # ################ helpers (nested or associated models)  ####################
        # ######## working with Friend model
            # ######## Friend model - friending process
                def initialize_friend_request(receiver)
                    self.sent_friendship_requests.new(request_receiver: receiver)
                end
                
                def decide_friend_request(other_user, action)
                    request = self.find_friendship_or_request(other_user)
                    request.assign_attributes(request_status: action)
                    request
                end

                def cancel_friendship_or_request(other_user)
                    self.find_friendship_or_request(other_user).destroy
                end

            # ######## Friend model - finding friend requests (not users) and request statuses
                def find_friendship_or_request(other_user)
                    friendship = self.sent_friendship_requests.where(request_receiver: other_user).first
                    friendship ||= self.received_friendship_requests.where(request_sender: other_user).first
                end

                            # def pending_sent_friend_requests
                            #     # Friend.where(request_sender: self).where(request_status: "pending")
                                
                            #     self.sent_friendship_requests.where(request_status: "pending")
                            # end

                            # def pending_received_friend_requests 
                            #     # Friend.where(request_receiver: self).where(request_status: "pending")
                                
                            #     self.received_friendship_requests.where(request_status: "pending")
                            # end

                def rejected?(other_user)
                    request = self.find_friendship_or_request(other_user)
                    request.request_status == "rejected" if request.present?
                end

            # ######## Friend model - finding friend request users
                def pending_request_receivers
                    User.where(id: [Friend.where(request_sender: self).where(request_status: "pending").pluck(:request_receiver_id)])
                end
        
                def pending_request_senders
                    User.where(id: [Friend.where(request_receiver: self).where(request_status: "pending").pluck(:request_sender_id)])
                end

                def pending_request_senders_and_receivers
                    request_users = pending_request_receivers.pluck(:id)
                    request_users << pending_request_senders.pluck(:id)
                    User.where(id: [request_users.flatten])
                end

                def non_contacted_users
                    User.where.not(
                        id: [Friend.where(request_sender: self).pluck(:request_receiver_id)]
                    ).where.not(
                            id: [Friend.where(request_receiver: self).pluck(:request_sender_id)]
                        ).where.not(
                                id: self.id
                            )
                end

                def request_receiver?(other_user)
                    self.pending_request_receivers.include?(other_user)
                end

                def request_sender?(other_user)
                    self.pending_request_senders.include?(other_user)
                end

                def friendship_initiated?(other_user)
                    self.pending_request_senders_and_receivers.include?(other_user)
                end

            # ######## Friend model - finding friends of current_user
                def friends
                    User.where(id: [Friend.where(request_sender: self).where(request_status: "accepted").pluck(:request_receiver_id)] ).or(
                        User.where(id: [Friend.where(request_receiver: self).where(request_status: "accepted").pluck(:request_sender_id)] )
                    )
                end

                def friend?(other_user)
                    self.friends.include?(other_user)
                end
                
                
        # ######## working with Profile Images 
            def fallback_profile_image
                fallback_image = {filename: "fallback-profile-img.png", display_name: "Default User Icon"}
            end
        
            def get_profile_image
                if self.oauth_default
                    image = self.image_url if self.image_url
                else
                    image = self.profile_image if !self.profile_image.id.nil?
                    image ||= self.fallback_profile_image[:filename]
                end
                image
            end

            def collect_image_positioning_data
                if self.profile_image.attached?
                    collection = {
                        obj_fit: self.profile_image.fit,
                        obj_pos: self.profile_image.position,
                        obj_vert: self.profile_image.vert_pos,
                        obj_horiz: self.profile_image.horiz_pos
                    }
                    collection.select { |key, value| value.present? }.blank? ? nil : collection
                end
            end
            

        # ######## working with Post, Comment, Like models
            # while interacting with posts, 
                # it can create a new post
                    # self.posts.build
                # it can find all of it's own posts
                    # self.posts.where(user: current_user)
                # it can find all posts of friends
                # it can comment on a post
                    # self.comments.build
                # it can like a post
                    # self.likes.build


    # ################ helpers (data control)  ####################
        def full_name
            "#{self.first_name.capitalize} #{self.last_name.capitalize}"
        end
        
        def format_names
            self.first_name = self.first_name.capitalize if self.first_name.present?
            self.last_name = self.last_name.capitalize if self.last_name.present?
        end
        
        def format_username
            self.username = self.username.downcase.gsub(" ","")
        end
        
        def format_email
            self.email = self.email.downcase.gsub(" ","")
        end
end


