require "rexml/document"

module HudsonHelper
  
  def hudson_link(text, project, system, additional_path)

    label = case system
      when "linux" then
        "Linux"
      when "mac" then
        "Mac"
      when "windows" then
        "Windows"
      end
    return '<a href="http://forge.typo3.org:8080/job/'+project.identifier+'/label='+label+additional_path+'">'+text+'</a>'
  end
  def hudson_watcher_tag(project, user)
    content_tag("span", hudson_watcher_link(project, user), :id => 'hudson_watcher')
  end

  def hudson_watcher_link(project, user)
    return '' unless user && user.logged?
    
    subscribed = JabberSubscription.find(:first, :conditions => ["project_id = ? AND user_id = ?", project.id, user.id])
    
    url = {:controller => 'hudson',
           :action => (subscribed ? 'unsubscribe' : 'subscribe'),
           :id => project.identifier}
    link_to_remote((subscribed ? "Unwatch builds" : "Watch builds"),
           {:url => url},
           :href => url_for(url),
           :class => (subscribed ? 'icon icon-fav' : 'icon icon-fav-off'))
  end
  
  
  def hudson_tabs
    return [{:name => "linux", :label => "Linux"},
            {:name => "mac", :label => "Mac"},
            {:name => "windows", :label => "Windows"}]
  end
  
  def format_health_score(score)
    score = score.to_i
    case score
      when 0..19 then
        return "00to19"
      when 20..39 then
        return "20to39"
      when 40..59 then
        return "40to59"
      when 60..69 then
        return "60to79"
      else
        return "80plus"
    end
  end
end
