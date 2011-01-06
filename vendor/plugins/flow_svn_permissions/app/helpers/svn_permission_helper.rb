class SvnPermissionHelper
  def self.write_all_authz_files()
      Setting.plugin_flow_svn_permissions[:authz_files].each{ |directory, authz|
        self.write_authz_file (directory, authz)
      }
  end 
  def self.write_authz_file(svn_directory, authz_file_location)
    projects = Project.find(:all)

    authz = { 'groups' => Array.new }
    authz['groups'] << "admins = " + User.find(:all, :conditions => ["admin = true"]).collect {|user| user.login }.join(', ')

    authz["/"] = ["@admins = rw"]

    local_server_url = Setting.plugin_flow_svn_permissions['local_server']

    projects.each do |project|
      if ((project.repository != nil) && (project.repository.url.include? local_server_url) && (project.repository.url.include? svn_directory))

        project_members = Array.new

        project.members.each do |member|
          member.roles.each do |role|
            if role.allowed_to? :write_svn
              project_members << member.user.login
            end
          end
        end
        authz['groups'] << self.generateGroupName(project) + " = " + project_members.join(', ')

        
        url = project.repository.url.gsub(local_server_url+svn_directory, '')
        # make sure that url does not end with /, as SVN gives errors then
        if url =~ /\/$/
          url.chop!
        end
	if (url == "")
           authz["/"] << "@" + self.generateGroupName(project) + " = rw" 
           if (project.is_public?)
             authz["/"] << "* = r"
           end
	else
           authz[url] = [ "@" + self.generateGroupName(project) + " = rw" ]
	end
      end # if project.repository != nil 
    end # projects.each
    
    authz_lines = Array.new

    authz = authz.sort.reverse # Make sure the "groups" section is on top of the file 

    authz.each { |key, values|
      authz_lines << "[#{key}]"
      values.each { |val|
        authz_lines << val
      }
      authz_lines << "\n"
    }
    authz_string = authz_lines.join "\n"
    #logger.info "Updating Authz file"
    File.open(authz_file_location+".writing", "w") do |file|
      file << authz_string
    end
    FileUtils.copy(authz_file_location, authz_file_location+".bak")
    FileUtils.move(authz_file_location+".writing", authz_file_location)
    
  end
  
  def self.generateGroupName(project)
    project.identifier+"-developers"
  end
end
