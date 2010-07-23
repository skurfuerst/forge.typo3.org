ActionController::Routing::Routes.draw do |map|
  map.connect 'services/projects', :controller => 'project_services', :action => 'index'
  map.connect 'services/projects/:id', :controller => 'project_services', :action => 'show'
end
