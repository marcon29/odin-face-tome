class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def hyphenate(string)
    string.gsub(" ","-").downcase
  end
    
  
end
