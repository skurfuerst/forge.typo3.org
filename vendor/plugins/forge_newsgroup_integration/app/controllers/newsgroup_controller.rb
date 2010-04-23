class NewsgroupController < ApplicationController
  unloadable
  before_filter :find_project
  layout 'base'
  
  def index
  	@newsgroup_name = ""
  	if (@project.newsgroup_name.match('^[a-z0-9.-]*$')) then
  	  @newsgroup_name = @project.newsgroup_name
  	end
  end
  
  def edit
    @project.newsgroup_name = params[:newsgroup][:newsgroup_name]
    @project.save
    
    render :text => " "
  end

private
  # Find project of id params[:id]
  # if not found, redirect to project list
  # Used as a before_filter
  def find_project
    @project = Project.find_by_identifier(params[:id])
  rescue ActiveRecord::RecordNotFound
  end


end