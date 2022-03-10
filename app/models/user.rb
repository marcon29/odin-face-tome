class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
    devise :omniauthable, omniauth_providers: %i[facebook github]

    has_many :sent_friendship_requests, foreign_key: "request_sender_id", class_name: "Friend"
    has_many :received_friendship_requests, foreign_key: "request_receiver_id", class_name: "Friend"
    # has_many :posts, :comments, :likes

    # attrs: :first_name, :last_name, :username, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at

    validates :first_name, presence: { message: "You must provide your first name." }
    validates :last_name, presence: { message: "You must provide your last name." }
    validates :username, 
        presence: { message: "You must provide a username." }, 
        uniqueness: { case_sensitive: false, message: "That username is already used." }, 
        format: { with: /\A\w+\z/, message: "Username can only use letters and numbers without spaces." }
    validates :email, format: { with: /\A\S+@\w+\.[a-zA-Z]{2,3}\z/, message: "Email doesn't look valid. Please use another." }
    before_validation :format_names, :format_username, :format_email

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
    def create_friend_request(receiver)
        self.sent_friendship_requests.create(request_receiver: receiver)
    end
    
    def decide_friend_request(sender, action)
        request = self.received_friendship_requests.where(request_sender: sender).first
        request.update(request_status: action)
    end
    
    def cancel_friendship_or_request(other_user)
        friendship = self.sent_friendship_requests.where(request_receiver: other_user).first
        if friendship.nil?
            friendship = self.received_friendship_requests.where(request_sender: other_user).first
        end
        friendship.destroy
    end
    
    def pending_sent_friend_requests
        Friend.where(request_sender: self).where(request_status: "pending")
    end
    
    def pending_received_friend_requests 
        Friend.where(request_receiver: self).where(request_status: "pending")
    end
    
    def friends 
        Friend.where(request_status: "accepted").and(
            Friend.where(request_sender: self).or(
            Friend.where(request_receiver: self)
            )
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

    

end
