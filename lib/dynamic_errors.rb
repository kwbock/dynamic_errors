require 'rubygems'

require 'active_record'
require 'action_controller'
if Rails.version >= "3"
  require 'active_record/errors'
  require 'dynamic_errors/engine'
end

module DynamicErrors
  class ActionController::Base
    # the following is for dynamic errors
    # consider moving this to lib/dynamic_errors.rb to create mixin module that can be reused
    # in Tapestry Adjustments case we want to redirect to the root path (search page)
    # include ConfigTest unless Rails.version < "3"
    
    if Rails.version >= "3"
      unless config.consider_all_requests_local
        rescue_from Exception, :with => :render_error
        rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
        rescue_from ActionController::RoutingError, :with => :render_not_found
        rescue_from ActionController::UnknownController, :with => :render_not_found
        # customize these as much as you want, ie, different for every error or all the same
        rescue_from ActionController::UnknownAction, :with => :render_not_found
      end
    end
    
    private
    
    def render_not_found(exception)
      # uncomment the following line land make sure that view exists for customized 404 error page
      render :template => "/errors/404.html.erb", :status => 404
      #redirect_to :root
    end
    
    def render_error(exception)
      # uncomment the following line and make sure that view exists for customized 500 error page
      render :template => "/errors/500.html.erb", :status => 500
      #redirect_to :root
    end
    
    def render_optional_error_file(status_code)
      puts "in here"
      status = interpret_status(status_code)
      render :template => "/errors/#{status[0,3]}.html.erb", :status => status, :layout => 'application.html.erb'
    end
  end
end
