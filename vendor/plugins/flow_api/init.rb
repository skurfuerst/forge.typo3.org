# Redmine sample plugin
require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting API plugin for Redmine'

Redmine::Plugin.register :flow_api_plugin do
  name 'API plugin'
  author 'Martin Herr <mt3x@yeebase.com>'
  description 'This is an api plugin for Redmine'
  version '0.0.1'
  settings :default => {'baseURL'=>'/data/bier'}, :partial => 'settings/settings'

  # This plugin adds a project module
  # It can be enabled/disabled at project level (Project settings -> Modules)
  project_module :api_module do
    # A public action
    permission :api_show, {:api => [:index]}, :public => true
  end

  # A new item is added to the project menu
  menu :project_menu, 'API', :controller => 'api', :action => 'index'
end
