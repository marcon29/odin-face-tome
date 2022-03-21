class StaticController < ApplicationController
  skip_before_action :redirect_if_not_signed_in
  
  def about
  end
end
