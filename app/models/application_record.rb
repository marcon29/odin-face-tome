class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def hyphenate(string)
    string.gsub(" ","-").downcase
  end

  def display_count(collection_or_int, text)
    qty = collection_or_int.class.name == "Integer" ? collection_or_int : collection_or_int.count
    display_text = qty == 1 ? text.singularize : text
    "#{qty} #{display_text}"
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
    # values usable for testing - need to change tests at some point
    # today =    DateTime.new(2022, 3,  8,  11, 10, 45).to_date
    # now =    DateTime.new(2022, 3,  8,  11, 10, 45).to_time
    today = DateTime.now.to_date
    now = DateTime.now.to_time
    date = self.created_at.to_date
    time = self.created_at.to_time

    check_date = (today - date).to_i
    check_time = (now - time).to_i
    
    if check_date >= 365
      self.display_count(check_date/365, "years")
    elsif check_date >= 30
      self.display_count(check_date/30, "months")
    elsif check_date >= 14
      self.display_count(check_date/7, "weeks")
    elsif check_date > 0
      self.display_count(check_date, "days")
    else
      if check_time >= 3600
        self.display_count(check_time/3600, "days")
      elsif check_time >= 60
        self.display_count(check_time/60, "days")
      else
        "seconds ago"
      end
    end
  end
end


