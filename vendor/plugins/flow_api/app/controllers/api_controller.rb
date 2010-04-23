# Sample plugin controller
class ApiController < ApplicationController
  unloadable
  
  layout 'base'  
  before_filter :find_project, :authorize
    
  def index
    @params = params
  end
    
private
  def find_project   
    @project=Project.find(params[:id])
  end
end
