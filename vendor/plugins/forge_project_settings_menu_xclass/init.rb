# Redmine sample plugin
require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Forge project settings menu XCLASS'

Redmine::Plugin.register :forge_project_settings_menu_xclass_plugin do
  name 'Forge Project settings menu xclass'
  author 'Sebastian Kurfuerst <sebastian@typo3.org>'
  description 'Extend the "project settings" menu'
  version '0.0.1'
end

