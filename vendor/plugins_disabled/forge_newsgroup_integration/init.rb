# Redmine newsgroup plugin
require 'redmine'

Redmine::Plugin.register :forge_newsgroup_integration_plugin do
  name 'Forge Newsgroup integration plugin'
  author 'Sebastian Kurfuerst <sebastian@typo3.org>'
  description 'Show newsgroups from support.typo3.org in forge.'
  version '0.0.1'
#  settings :default => {'baseURL'=>'/data/bier'}, :partial => 'settings/settings'

  # This plugin adds a project module
  # It can be enabled/disabled at project level (Project settings -> Modules)
  project_module :newsgroup_module do
    # A public action
    permission :newsgroup_show, {:newsgroup => [:index]}, :public => true
  end

  # A new item is added to the project menu
  menu :project_menu, 'Newsgroup', :controller => 'newsgroup', :action => 'index'
end
