class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
    devise :omniauthable, omniauth_providers: %i[facebook]

    has_one_attached :profile_image

    has_many :sent_friendship_requests, foreign_key: "request_sender_id", class_name: "Friend"
    has_many :received_friendship_requests, foreign_key: "request_receiver_id", class_name: "Friend"
    # has_many :posts, :comments, :likes

    # attrs: :first_name, :last_name, :username, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
    # accepts_nested_attributes_for :profile_image

    validates :first_name, presence: { message: "You must provide your first name." }
    validates :last_name, presence: { message: "You must provide your last name." }
    validates :username, 
        presence: { message: "You must provide a username." }, 
        uniqueness: { case_sensitive: false, message: "That username is already used." }, 
        format: { with: /\A\w+\z/, message: "Username can only use letters and numbers without spaces." }
    validates :email, format: { with: /\A\S+@\w+\.[a-zA-Z]{2,3}\z/, message: "Email doesn't look valid. Please use another." }
    before_validation :format_names, :format_username, :format_email

    # image_url 
        # needs to be unique
        # must end in .jpg or .png || or being with https:// or http://


    # after_validation :check_method
    # def check_method
    #     binding.pry
    # end


    # ################ helpers (callbacks & control flow)  ####################
   
        

    # ################ helpers (instantiation & validation)  ####################
    # auth arg will be the data hash from provider
    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
            user.email = auth.info.email
            user.password = Devise.friendly_token[0,20]
            user.first_name = auth.info.name.split(" ").first
            user.last_name = auth.info.name.split(" ").last
            user.username = auth.info.name.gsub(" ","").downcase
            user.image_url = auth.info.image
        end
    end



    # ################ helpers (nested or associated models)  ####################
    
    # ######## working with Friend model
    def initialize_friend_request(receiver)
        self.sent_friendship_requests.new(request_receiver: receiver)
    end
    
    def decide_friend_request(sender, action)
        request = self.received_friendship_requests.where(request_sender: sender).first
        request.assign_attributes(request_status: action)
        request
    end

    def cancel_friendship_or_request(other_user)
        self.find_friendship_or_request(other_user).destroy
    end
    
    def find_friendship_or_request(other_user)
        friendship = self.sent_friendship_requests.where(request_receiver: other_user).first
        friendship ||= self.received_friendship_requests.where(request_sender: other_user).first
    end

    def rejected?(other_user)
        request = self.find_friendship_or_request(other_user)
        request.request_status == "rejected" if request.present?
    end
    
    # --------------------------
    # find pending sent requests and all who user sent requests to
    
    def pending_request_receivers
        # self.pending_sent_friend_requests.collect { |req| req.request_receiver }
        
        User.where(id: [Friend.where(request_sender: self).where(request_status: "pending").pluck(:request_receiver_id)])
        
        # check = User.where(id: 984941)
    end

    # def pending_sent_friend_requests
    #     # Friend.where(request_sender: self).where(request_status: "pending")
        
    #     self.sent_friendship_requests.where(request_status: "pending")
    # end

    # --------------------------
    # find pending received requests and all who user received requests from
    
    def pending_request_senders
        # self.pending_received_friend_requests.collect { |req| req.request_sender }
        
        User.where(id: [Friend.where(request_receiver: self).where(request_status: "pending").pluck(:request_sender_id)])
        
        # check = User.where(id: 984941)
    end
    
    # def pending_received_friend_requests 
    #     # Friend.where(request_receiver: self).where(request_status: "pending")
        
    #     self.received_friendship_requests.where(request_status: "pending")
    # end

    def request_receiver?(other_user)
        self.pending_request_receivers.include?(other_user)
    end

    def request_sender?(other_user)
        self.pending_request_senders.include?(other_user)
    end

    def pending_request_senders_and_receivers
        request_users = pending_request_receivers.pluck(:id)
        request_users << pending_request_senders.pluck(:id)
        User.where(id: [request_users.flatten])
    end

    def friendship_initiated?(other_user)
        self.pending_request_senders_and_receivers.include?(other_user)
    end
    
    # --------------------------

    def friends
        User.where(id: [Friend.where(request_sender: self).where(request_status: "accepted").pluck(:request_receiver_id)] ).or(
            User.where(id: [Friend.where(request_receiver: self).where(request_status: "accepted").pluck(:request_sender_id)] )
        )
    end

    def friend?(other_user)
        self.friends.include?(other_user)
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

    def get_profile_image
        if self.oauth_default
            image = self.image_url if self.image_url
        else
            image = self.profile_image if self.profile_image.present?
            image ||= self.image_url if self.image_url
            image ||= "profile-img-placeholder.png"
        end
        image
    end
        

    

end
