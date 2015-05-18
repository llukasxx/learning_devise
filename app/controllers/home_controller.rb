class HomeController < ApplicationController

  
  def index
    if !current_user.nil?
      redirect_to :controller => 'posts', :action => 'index'
    end
  end

  def new
    
  end

  def edit
    
  end
  
end
