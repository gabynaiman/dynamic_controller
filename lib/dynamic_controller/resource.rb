module DynamicController
  class Resource
    attr_accessor :resource_class,
                  :param_name,
                  :instance_variable_name,
                  :children_name

    def initialize(options={})
      raise 'Param resource_class must be a class' if !options.has_key?(:resource_class) || !options[:resource_class].is_a?(Class)
      @resource_class = options[:resource_class]
      @param_name = options[:param_name] || "#{resource_class.to_s.demodulize.underscore}_id"
      @instance_variable_name = options[:instance_variable_name] || "@#{resource_class.to_s.demodulize.underscore}"
      @children_name = options[:children_name] || resource_class.to_s.demodulize.pluralize.underscore
    end

    def find(id)
      resource_class.find(id)
    end

  end
end
