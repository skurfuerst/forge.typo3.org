class MetricController < ApplicationController
  unloadable
  
  layout 'base'  
  before_filter :find_project, :authorize
    
  def index
    @params = params
    @metric_tabs = [
      {:name => 'compliancy', :partial => 'compliancy', :label => :label_compliancy},
      #{:name => 'overview', :partial => 'overview', :label => :label_overview},  
      #{:name => 'tests', :partial => 'tests', :label => :label_tests},
      #{:name => 'coverage', :partial => 'coverage', :label => :label_coverage},
          ]
	 
    # LOAD CGL DATA
    
    basedir = "/home/forge/continous-integration/server/results/#{@project.name}/"

    @revision = Dir.entries(basedir).fetch(-1)
    cgl_filename = "#{basedir}#{@revision}/cgl.html"
    
    @cgl_data = IO.read(cgl_filename)
  end
    
private
  def find_project   
    @project=Project.find(params[:id])
  end
end
