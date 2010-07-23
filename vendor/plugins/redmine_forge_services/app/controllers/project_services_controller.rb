class ProjectServicesController < ApplicationController
  unloadable

  skip_before_filter :check_if_login_required

  def index
    @projects = Project.active.all_public

    respond_to do |format|
      format.json do
        render :json => @projects.to_json(
          :only => [:name, :description, :identifier]
        )
      end
    end
  end

  def show
    @project = Project.active.all_public.find(params[:id])

    respond_to do |format|
      format.json do
        render :json => @project.to_json(
          :only => [:name, :description, :identifier],
          :include => {
            :members => {
              :include => {
                :user => {
                  :only => [:id, :login, :firstname, :lastname, :img_hash]
                },
                :roles => {
                  :only => :name
                }
              }
            }
          }
        )
      end
    end
  end
end