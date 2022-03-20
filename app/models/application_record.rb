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


  def time_since_creation
    now = DateTime.now.to_date
    pres = DateTime.now.to_time
    # now =    DateTime.new(2022, 3,  8,  11, 10, 45).to_date
    # pres =    DateTime.new(2022, 3,  8,  11, 10, 45).to_time

    date = self.created_at.to_date
    time = self.created_at.to_time

    check_date = (now - date).to_i
    check_time = (pres - time).to_i
    
    if check_date >= 365
      "#{check_date/365} year#{'s' if check_date/365 != 1} ago"

    elsif check_date >= 30
      "#{check_date/30} month#{'s' if check_date/30 != 1} ago"

    elsif check_date >= 14
      "#{check_date/7} week#{'s' if check_date/7 != 1} ago"

    elsif check_date > 0
      "#{check_date} day#{'s' if check_date != 1} ago"

    else
      if check_time >= 3600
        "#{check_time/3600} hour#{'s' if check_time/3600 != 1} ago"

      elsif check_time >= 60
        "#{check_time/60} minute#{'s' if check_time/60 != 1} ago"

      else
        "seconds ago"
      end
    end
  end


  
end


