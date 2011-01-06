# Redmine Automatic Generation of SVN authz file
# includes the appropriate permission

require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting SVN Auth plugin for Redmine'

Redmine::Plugin.register :flow_svn_permissions do
  name 'SVN Permissions plugin'
  author 'Sebastian Kurfuerst <sebastian@typo3.org>'
  description 'This is a SVN Permission plugin for Redmine'
  version '0.0.1'
  settings :default => {
    :authz_files => {
      '/Teams' => '/var/svn/teams/conf/authz',
      '/FLOW3' => '/var/svn/flow3/conf/authz',
      '/TYPO3v5' => '/var/svn/typo3v5/conf/authz',
      '/TYPO3v4/Core' => '/var/svn/typo3v4/core/conf/authz',
      '/TYPO3v4/CoreProjects' => '/var/svn/typo3v4/core_projects/conf/authz',
      '/TYPO3v4/Extensions' => '/var/svn/typo3v4/extensions/conf/authz',
      '/TYPO3v4/Documentation' => '/var/svn/typo3v4/documentation/conf/authz',
      '/projects/typo3org' => '/var/svn/projects/typo3org/conf/authz'
    },
    'local_server' => 'https://svn.typo3.org'
    }

  Redmine::AccessControl.map do |map|
    map.permission :write_svn, {}, :require => :member
  end
end



