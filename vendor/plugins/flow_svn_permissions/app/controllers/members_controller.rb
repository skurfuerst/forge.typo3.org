#require "../helpers/SvnPermissionHelper"
#require_dependency "MembersController"
require "#{RAILS_ROOT}/vendor/plugins/flow_svn_permissions/app/helpers/svn_permission_helper.rb"
class MembersController < ApplicationController
  unloadable
  after_filter :write_all_authz_files, :except => :autocomplete_for_member
private

  
  def write_all_authz_files()
     SvnPermissionHelper.write_all_authz_files
  end
end
