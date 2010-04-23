# Redmine plugin
require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting "longer project names"'

Redmine::Plugin.register :longer_project_names do
  name 'Longer project names plugin'
  author 'Sebastian Kurfuerst <sebastian@typo3.org>'
  description 'Fix of bug 440'
  version '0.0.1'
end

#require 'project.rb'


#class Project < ActiveRecord::Base 
#  validates_length_of :identifier, :in => 3..64
#end
