require 'ransack'
require 'kaminari'

require 'dynamic_controller/version'
require 'dynamic_controller/resource'
require 'dynamic_controller/helper_methods'
require 'dynamic_controller/class_methods'
require 'dynamic_controller/instance_methods'

ActionController::Base.send :extend, DynamicController::ClassMethods

