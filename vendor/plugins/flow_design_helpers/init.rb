# Helper DB migrations for the design
# Adds fields for the project image, etc
require 'redmine'

require 'dispatcher'
Dispatcher.to_prepare do
  ApplicationController.helper(MenuGeneratorHelper)
end

