class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def hyphenate(string)
    string.gsub(" ","-").downcase
  end

  # (for Post and Comment) can remove beginning and trailing white space
  def format_content
    self.content = self.content.strip
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
