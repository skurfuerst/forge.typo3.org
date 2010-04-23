class HudsonController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project
  before_filter :require_login, :only => [:subscribe, :unsubscribe]
  helper :hudson
  
  def index
    begin
      queries = {
        :lastBuildNumber => '//lastBuild/number/text()',
        :color => '//color/text()',
        :health => '//healthReport/description[starts-with(., "Build stability")]/text()',
        :health_score => '//healthReport/description[starts-with(., "Build stab")]/../score/text()'
      }
      platform_queries = {
        :color => '//color/text()',
        #:health_score => '//healthReport/description[starts-with(., "Build stab")]/../score/text()',
        :test_summary => '//healthReport/description[starts-with(., "Test")]/text()',
        :test_score => '//healthReport/description[starts-with(., "Test")]/../score/text()'
      }
      @details = hudson_job_details(@project, '', queries)
      @platform_details = {
        "linux" => hudson_job_details(@project, '/label=Linux', platform_queries),
        "mac" => hudson_job_details(@project, '/label=Mac', platform_queries),
        "windows" => hudson_job_details(@project, '/label=Windows', platform_queries)
      }
      @platform_test_results = {
        "linux" => hudson_job_details(@project, '/label=Linux/lastSuccessfulBuild/testReport', false, "?xpath=//child[statu!='PASSED']&wrapper=outer"),
        "mac" => hudson_job_details(@project, '/label=Mac/lastSuccessfulBuild/testReport', false, "?xpath=//child[statu!='PASSED']&wrapper=outer"),
        "windows" => hudson_job_details(@project, '/label=Windows/lastSuccessfulBuild/testReport', false, "?xpath=//child[statu!='PASSED']&wrapper=outer")
      }
      
    rescue
      @no_data_yet = true
    end
  end

  def settings
    if (request.post?)
      @hudson.package_key = params[:hudson][:package_key]
      if (params[:hudson][:disabled].to_i == 1) then
        @hudson.disabled = true
      else
        @hudson.disabled = false
      end
      @hudson.svn_url = File.join(@project.repository.url, '/trunk/')
      @hudson.save
    else
      render :action => 'settings', :layout => false
    end
  end
  
  def subscribe
    if (!User.current.jabber_id or User.current.jabber_id == "") then
      render_subscription
    end
    subscription = JabberSubscription.new(:user_id => User.current.id, :project_id => @project.id)
    subscription.save()
    @hudson.jabber_users << User.current.jabber_id
    @hudson.save
    render_subscription
  end
  
  def unsubscribe
    subscription = JabberSubscription.find(:first, ['user_id = ? AND project_id = ?', User.current.id, @project.id])
    subscription.destroy
    @hudson.jabber_users.delete(User.current.jabber_id)
    @hudson.save
    render_subscription
  end

private
  def find_project
    @project = Project.find_by_identifier(params[:id])
    @hudson = Hudson.new(@project.identifier, @project.repository.url)
  rescue ActiveRecord::RecordNotFound
  end
  
  def hudson_job_details(project, url_part, xpath_hash, postproc='')
      url = 'http://forge.typo3.org:8080/job/'+project.identifier+url_part+'/api/xml'+postproc
      RAILS_DEFAULT_LOGGER.debug("!!!!! SK URL "+url)
      full_body = Net::HTTP.get_response(URI.parse(url)).body
      
      doc = REXML::Document.new full_body
      if (xpath_hash != false)
        values = {}
        xpath_hash.each {|k, v|
          begin
            el = REXML::XPath.first(doc, v)
            values[k] = el.to_s
          rescue
            values[k] = "There was a problem extracting the value "+k
          end
        }
        return values
      else
        return doc
      end
  end

  def render_subscription
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render(:update) {|page| page.replace_html 'hudson_watcher', hudson_watcher_link(@project, User.current)} }
    end
  end

end
  
