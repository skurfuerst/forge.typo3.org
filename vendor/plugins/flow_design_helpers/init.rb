# Helper DB migrations for the design
# Adds fields for the project image, etc
require 'redmine'

config.to_prepare do
  ApplicationController.helper(MenuGeneratorHelper)
end

