class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def hyphenate(string)
    string.gsub(" ","-").downcase
  end

  # (for Post and Comment) can remove beginning and trailing white space
  def format_content
    self.content = self.content.strip
  end

  def check_user_and_post_updating
    if self.persisted?
        errors.add(:user_id, "Can't change the user.") if self.user_id_changed? 
        errors.add(:post_id, "Can't change the post.") if self.post_id_changed? 
    end
end

  def get_flash_errors
    if self.errors.any?
      emsg = []
      self.errors.messages.each do |attr, msg|
        emsg << msg.first if attr
      end
    end
    emsg.first
  end
  
end
