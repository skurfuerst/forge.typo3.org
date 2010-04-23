# Helper DB migrations for the design
# Adds fields for the project image, etc
require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Design Helpers plugin'

require File.dirname(__FILE__) + '/lib/project_extender'
