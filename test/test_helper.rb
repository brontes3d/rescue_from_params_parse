require 'rubygems'
require 'active_support'
require 'active_support/test_case'

require 'action_controller'
require 'action_controller/test_case'
require 'action_controller/test_process'

unless defined?(RAILS_ROOT)
 RAILS_ROOT = ENV["RAILS_ROOT"] || File.expand_path(File.join(File.dirname(__FILE__), "mocks"))
end
# RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
RAILS_DEFAULT_LOGGER = Logger.new(nil)

require File.join(File.dirname(__FILE__), "..", "init")

require File.join(File.dirname(__FILE__), 'mocks/controllers')

ActionController::Routing::Routes.clear!
ActionController::Routing::Routes.draw {|m| 
  m.connect 'without_rescue_from/:action', :controller => 'without_rescue_from'
  m.connect 'with_rescue_from/:action', :controller => 'with_rescue_from'
}