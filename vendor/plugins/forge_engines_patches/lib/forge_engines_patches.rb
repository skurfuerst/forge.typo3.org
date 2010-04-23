# ForgeEnginesPatches   

module Engines
  class Plugin < Rails::Plugin
    
    # Adds the view path of a plugin at the beginning of the view path array. So Rails first looks for the view in the plugin folder,
    # if a plugin is in the list of patch plugins.
    def prepend_view_paths
      view_path = File.join(directory, 'app', 'views')
      if File.exist?(view_path)
        ActionController::Base.view_paths.insert(0, view_path) # Put the path at position 0!
        ActionView::TemplateFinder.process_view_paths(view_path)
      end      
    end 
    
  end
end


module Engines::RailsExtensions::Dependencies
  
  def self.included(base) #:nodoc:
    base.class_eval { alias_method_chain :require_or_load, :engine_additions }
  end

  # Attempt to load the given file from any plugins, as well as the application.
  # This performs the 'code mixing' magic, allowing application controllers and
  # helpers to override single methods from those in plugins.
  # If the file can be found in any plugins, it will be loaded first from those
  # locations. Finally, the application version is loaded, using Ruby's behaviour
  # to replace existing methods with their new definitions.
  #
  # If <tt>Engines.disable_code_mixing == true</tt>, the first controller/helper on the
  # <tt>$LOAD_PATH</tt> will be used (plugins' +app+ directories are always lower on the
  # <tt>$LOAD_PATH</tt> than the main +app+ directory).
  #
  # If <tt>Engines.disable_application_code_loading == true</tt>, controllers will
  # not be loaded from the main +app+ directory *if* they are present in any
  # plugins.
  #
  # Returns true if the file could be loaded (from anywhere); false otherwise -
  # mirroring the behaviour of +require_or_load+ from Rails (which mirrors
  # that of Ruby's own +require+, I believe).
  def require_or_load_with_engine_additions(file_name, const_path=nil)
    return require_or_load_without_engine_additions(file_name, const_path) if Engines.disable_code_mixing

    # PATCH begin
    # Mike Zaschka <mike.zaschka@dkd.de>    
    # Load list with plugins which should override stuff in the app folder
    
    patch_plugins = YAML::load(File.open("#{RAILS_ROOT}/config/patch_plugins.yml"))
    
    # PATCH end
    
    file_loaded = false

    # try and load the plugin code first
    # can't use model, as there's nothing in the name to indicate that the file is a 'model' file
    # rather than a library or anything else.
    Engines.code_mixing_file_types.each do |file_type| 
      # if we recognise this type
      # (this regexp splits out the module/filename from any instances of app/#{type}, so that
      #  modules are still respected.)
      if file_name =~ /^(.*app\/#{file_type}s\/)?(.*_#{file_type})(\.rb)?$/
        base_name = $2
        # ... go through the plugins from first started to last, so that
        # code with a high precedence (started later) will override lower precedence
        # implementations
        Engines.plugins.each do |plugin|
          
          # PATCH begin
          # Mike Zaschka <mike.zaschka@dkd.de>

          if patch_plugins.include?(plugin.name) then next end  
            
          # PATCH end
          
          plugin_file_name = File.expand_path(File.join(plugin.directory, 'app', "#{file_type}s", base_name))
          Engines.logger.debug("checking plugin '#{plugin.name}' for '#{base_name}'")
          if File.file?("#{plugin_file_name}.rb")
            Engines.logger.debug("==> loading from plugin '#{plugin.name}'")
            file_loaded = true if require_or_load_without_engine_additions(plugin_file_name, const_path)
          end
        end
    
        # finally, load any application-specific controller classes using the 'proper'
        # rails load mechanism, EXCEPT when we're testing engines and could load this file
        # from an engine
        if Engines.disable_application_code_loading
          Engines.logger.debug("loading from application disabled.")
        else
          # Ensure we are only loading from the /app directory at this point
          app_file_name = File.join(RAILS_ROOT, 'app', "#{file_type}s", "#{base_name}")
          if File.file?("#{app_file_name}.rb")
            Engines.logger.debug("loading from application: #{base_name}")
            file_loaded = true if require_or_load_without_engine_additions(app_file_name, const_path)
          else
            Engines.logger.debug("(file not found in application)")
          end
        end
        
        # PATCH begin
        # Mike Zaschka <mike.zaschka@dkd.de>
        #
        # We would like to override some functions of redmine so we need to load things from the common "app"
        # folder first and then the specific plugins.
        
        Engines.plugins.each do |plugin|
          
          # Only use specific plugins 
          unless patch_plugins.include?(plugin.name) then next end  
            
          plugin_file_name = File.expand_path(File.join(plugin.directory, 'app', "#{file_type}s", base_name))
          Engines.logger.debug("checking plugin '#{plugin.name}' for '#{base_name}'")
          if File.file?("#{plugin_file_name}.rb")
            plugin.prepend_view_paths
            Engines.logger.debug("==> Realoading from plugin after app '#{plugin.name}'")
            file_loaded = true if require_or_load_without_engine_additions(plugin_file_name, const_path)
          end
        end
        
        # PATCH end
                
      end 
    end

    # if we managed to load a file, return true. If not, default to the original method.
    # Note that this relies on the RHS of a boolean || not to be evaluated if the LHS is true.
    file_loaded || require_or_load_without_engine_additions(file_name, const_path)
  end  
end

module ::Dependencies #:nodoc:
  include Engines::RailsExtensions::Dependencies
end