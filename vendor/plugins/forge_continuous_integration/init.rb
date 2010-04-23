require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Continuous Integration Plugin for Forge'

Redmine::Plugin.register :forge_continuous_integration do
  name 'Continuous Integration'
  author 'Sebastian Kurfuerst <sebastian@typo3.org>'
  description 'CI with Hudson integration'
  version '0.0.1'
  settings :default => {
    'hudson_work_directory' => '/home/hudson/.hudson/'
    #'hudson_work_directory' => '/tmp/hudson/'
  }, :partial => 'settings/settings'
  project_module :hudson_module do
    permission :hudson_show, {:hudson => [:index]}, :public => true
  end
  # A new item is added to the project menu
  menu :project_menu, 'Continuous Integration', :controller => 'hudson', :action => 'index'
end
