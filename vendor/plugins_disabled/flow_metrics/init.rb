# Redmine metrics plugin
require 'redmine'

Redmine::Plugin.register :metrics_plugin do
  name 'Metrics plugin'
  author 'Martin Herr <mt3x@yeebase.com>'
  description 'This is a metrics plugin for Redmine'
  version '0.0.2'
  settings :default => {'metrics_path'=>'/data/bier'}, :partial => 'settings/settings'

  # This plugin adds a project module
  # It can be enabled/disabled at project level (Project settings -> Modules)
  project_module :metrics_module do
    # A public action
    permission :metrics_show, {:metric => [:index]}, :public => true
    # This permission has to be explicitly given
    # It will be listed on the permissions screen
    permission :metrics_say_goodbye, {:metric => [:say_goodbye]}
  end

  # A new item is added to the project menu
  menu :project_menu, "Metrics", :controller => 'metric', :action => 'index'
end
