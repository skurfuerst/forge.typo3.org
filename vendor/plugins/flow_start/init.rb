# Redmine sample plugin
require 'redmine'

Redmine::Plugin.register :flow_start do
  name 'Startpage plugin'
  author 'Martin Herr <mt3x@yeebase.com>, Sebastian Kurfuerst <sebastian@typo3.org>'
  description 'This is a startpage plugin for Redmine'
  version '0.0.1'
  #local_server_url = Setting.plugin_flow_svn_permissions['local_server']
  settings :default => {
    
    'own_projects_version4_parent_identifier' => 'extensions', # TODO - needs to be some extension identifier
    'own_projects_version4_identifier_prefix' => 'extension-',
    'own_projects_version4_svn_base_path' => 'TYPO3v4/Extensions/', # WITHOUT / in front, WITH / at the end
    'own_projects_version4_base_directory' => 'file:///var/svn/typo3v4/extensions/', # WITH / at the end
    
    'own_projects_version5_parent_identifier' => 'packages', # TODO: sandbox
    'own_projects_version5_identifier_prefix' => 'package-',
    'own_projects_version5_svn_base_path' => 'FLOW3/Packages/', # WITHOUT / in front, WITH / at the end
    'own_projects_version5_base_directory' => 'file:///var/svn/flow3/Packages/', # WITH / at the end
    
    'own_projects_svn_base_url' => 'https://svn.typo3.org/',  # WITH / at the end
    'own_projects_first_user_role_id' => 7 # Team leader
    }, :partial => 'settings/settings'
end
