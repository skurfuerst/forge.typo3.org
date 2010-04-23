require 'fileutils'
require "rexml/document"

class Hudson

  def initialize(identifier, project_svn)
    base_directory = Setting.plugin_forge_continuous_integration['hudson_work_directory']
    directory = base_directory + 'jobs/' + identifier
    #FileUtils.mkdir_p directory
    
    @config_file = directory + '/config.xml'
    @identifier = identifier
    
    @init_needed = false
    
    if (!File.exists?(@config_file)) then
      @init_needed = true
      
      @disabled = true
      @svn_url = project_svn
      @package_key = identifier
      @jabber_users = Array.new
    else
      file = File.new( @config_file )
      doc = REXML::Document.new file
      
      initialize_disabled doc
      initialize_svn_url doc
      initialize_package_key doc
      initialize_jabber_users doc
    end
  end
  
  def save
    ### Read out configuration template
    file = File.new( "#{RAILS_ROOT}/vendor/plugins/forge_continuous_integration/app/views/hudson/_hudson_config_template.xml" )
    doc_template = REXML::Document.new file
    
    ### Write setting nodes
    # Write disabled setting
    node = REXML::XPath.first( doc_template, "//disabled")
    if (@disabled) then
      node.text = "true"
    else
      node.text = "false"
    end
    
    # Write svn URL
    @svn_url = @svn_url.sub(/\/$/, "") # Strip last / if it exists
    node = REXML::XPath.first( doc_template, "//hudson.scm.SubversionSCM_-ModuleLocation/remote")
    node.text = @svn_url
    
    # Package Key
    node = REXML::XPath.first( doc_template, "//builders/hudson.tasks.Shell/command" )
    node.text = 'cd ../../../../helpers/

if [ "$OS" = "Windows_NT" ]; then
      phing/bin/phing.bat -f build.xml all -Dpackage='+@package_key+'
else
      phing/bin/phing -f build.xml all -Dpackage='+@package_key+'
fi'

    # Jabber Users
    write_jabber_users(doc_template)
    
    ### Read out xml file as string
    text = ""
    doc_template.write(text)
    
    save_config_to_hudson(text)
  end
  ### GETTERS / SETTERS
  # The disabled setting
  def disabled
    return @disabled
  end
  def disabled=(new_state)
    @disabled = new_state
  end
  
  # the SVN URL
  def svn_url
    return @svn_url
  end
  def svn_url=(new_svn_url)
    @svn_url = new_svn_url
  end
  
  # Package key
  def package_key
    return @package_key
  end
  def package_key=(new_package_name)
    @package_key = new_package_name
  end
  
  def jabber_users
    return @jabber_users
  end
private
  ### INITIALIZATION
  def initialize_disabled(doc)
    if (REXML::XPath.first( doc, "//disabled" ).text.strip == 'true') then
      @disabled = true
    else
      @disabled = false
    end
  end
  
  def initialize_svn_url(doc)
    @svn_url = REXML::XPath.first( doc, "//hudson.scm.SubversionSCM_-ModuleLocation/remote").text
  end
  
  def initialize_package_key(doc)
    command = REXML::XPath.first( doc, "//builders/hudson.tasks.Shell/command" ).text
    @package_key = command.match('Dpackage=(.*)$')[1]
  end
  
  def initialize_jabber_users(doc)
    @jabber_users = Array.new
    REXML::XPath.each(doc, "//publishers/hudson.plugins.jabber.im.transport.JabberPublisher/targets/hudson.plugins.jabber.im.DefaultIMMessageTarget/value") {
    |element|
      @jabber_users << element.text
    }
  end
  def write_jabber_users(doc_template)
    node = REXML::XPath.first(doc_template, "//publishers/hudson.plugins.jabber.im.transport.JabberPublisher/targets/")
    @jabber_users.each { |user|
      node2 = node.add_element "hudson.plugins.jabber.im.DefaultIMMessageTarget"
      value_node = node2.add_element "value"
      value_node.text = user
    }
  end
  
  def save_config_to_hudson(xmltext)
    Net::HTTP.new('localhost', 8080).start do |http|
      #make the initial get to get the JSESSION cookie
      get = Net::HTTP::Get.new('/')
      response = http.request(get)
      cookie = response.response['set-cookie'].split(';')[0]
    
      #authorize
      post = Net::HTTP::Post.new('/j_security_check')
      user = AppConfig.hudson_user
      password = AppConfig.hudson_password

      post.set_form_data({'j_username'=> user, 'j_password'=>password})
      post['Cookie'] = cookie
      http.request(post)
    
      url = ""
      if (@init_needed) then
        url = "/createItem?name="+@identifier
      else
        url = "/job/"+@identifier+"/config.xml"
      end
      
      http.post(url, xmltext, {"Content-Type" => "text/xml", "Cookie" => cookie})
    end
  end
end
