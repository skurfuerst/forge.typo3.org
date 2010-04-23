module MenuGeneratorHelper
  

  def left_menu_tabs
    tabs = [ { :name => 'menu', :label => 'Menu', :partial => 'left_menu/menu.rhtml' },
	     { :name => 'actions', :label => 'Actions', :partial => 'left_menu/actions.rhtml' } ]
    return tabs
  end
  def render_header_image (project)
    out = ""
    if project then
       if project.topbarbackgroundcolor? then
        out += 'background-color:'+project.topbarbackgroundcolor+';'
       end
       if FileTest.exist?("#{RAILS_ROOT}/public/images/headerimages/"+project.id.to_s+'.jpg') then
        out += 'background-image:url(/images/headerimages/'+project.id.to_s+'.jpg);'
       end
       out = ' style="' + out + '"'
    end
    return out
  end
  
  
  def render_header_textcolor (project)
    out = ""
    if project then
       if project.topbartextcolor? then
        out += 'color:'+project.topbartextcolor
       end
    end
    return out
  end

  def render_header_menu (project)
    out = ""
    ### HEADER MENU ###
    # Highlight current top menu item
    identifier = 'start'
    if (project) then
      identifier = get_parent_project_identifiers(project).last
    end

    # Display START
    htmlOptions = {
      :class => 'start'
    }
    if (identifier == 'start') then
      htmlOptions[:class] += ' current'
    end
    out += link_to "Start", {:controller => 'start', :action => 'index'}, htmlOptions

    # Display Subprojects
    Project.find(:all, :conditions => 'parent_id IS NULL', :order => :sorting).each { |prj|
      out += generate_link_to_project (prj, (identifier == prj.identifier), 0)
    }
    return out
  end
  
  def render_left_menu (project)
    out = ''
    if (project  and project.id ) then
      @projectidentifier = project.identifier
      rootline = get_parent_project_identifiers(project)
      firstLevelProject = Project.find(rootline.last)
      out += outputProjectsRecursively(firstLevelProject, rootline, 1)
    else # No project selected
      out += link_to "About", {:controller => 'start', :action => 'about'}
      out += link_to "Register project", {:controller => 'start', :action => 'createProject'}
    end
    return out;
  end
private

  def get_parent_project_identifiers (project) 
    parentProjects = Array.new
    parentProjects << project.identifier
    while (project.parent != nil) do
      project = project.parent
      parentProjects << project.identifier
    end
    return parentProjects
  end
  
  def generate_link_to_project (project, active, level) 
#    if (! project.visible_by(User.current)) then
#      return ""
#    end
    htmlOptions = {
      :class => 'level-'+level.to_s
    }
    if (active) then
      htmlOptions[:class] += ' current'
    end
    
    htmlOptions[:class] += ' sorting-'+project.sorting.to_s
    
    return link_to project.name, {:controller => 'projects', :action => 'show', :id => project.identifier }, htmlOptions
  end
  
  def outputProjectsRecursively (project, rootline, level, inSelectTag = false)
    out = ''
    
    projects = Project.find(:all, :order => "sorting, name", :conditions => [Project.visible_by(User.current) + " AND parent_id = ?", project.id])
    
    if (inSelectTag || ( level == 2 && projects.length > 20 ) ) then
	if (level == 2) then
	    out += '<select onchange="window.location.href=\'/projects/show/\'+this.value"><option value="extensions">- Select Subproject-</option>'
	end
	projects.each { |prj|
	    select = ''
	    if (prj.identifier == @projectidentifier) then
		select = 'selected="selected"'
	    end
	    out += '<option '+select+' value="'+prj.identifier+'">'+prj.name+'</option>'
	    out += outputProjectsRecursively(prj, rootline, level+1, true)
	}
	
	if (level == 2) then
	    out += '</select>'
	end
    else
        projects.each { |prj|
          if (rootline.include? prj.identifier) then # Selected menu item
            out += generate_link_to_project(prj, true, level)
            out += outputProjectsRecursively(prj, rootline, level + 1)
          else # Not selected menu item
            out += generate_link_to_project(prj, false, level)
          end
	}
    end
    return out
  end
end
