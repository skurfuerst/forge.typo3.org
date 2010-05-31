require File.dirname(__FILE__) + '/../../../lib/mylyn_connector'

class MylynConnector::ProjectsController < ApplicationController
  unloadable
  include MylynConnector::Rescue::ClassMethods

  skip_before_filter :verify_authenticity_token

  before_filter :find_project, :only => [:get]

  helper MylynConnector::MylynHelper

  def all
    @projects = Project.find(:all,
      :joins => :enabled_modules,
      :conditions => [ "enabled_modules.name = 'issue_tracking' AND #{Project.visible_by}"])

    respond_to do |format|
      format.xml {render :xml => @projects, :template => 'mylyn_connector/projects/all.rxml'}
    end
  end

  private
  def find_project
    @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end
  
end
