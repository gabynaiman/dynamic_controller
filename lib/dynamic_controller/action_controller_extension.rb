module DynamicController
  module ActionControllerExtension

    def has_crud_actions(options={})
      @resource_options = Hash[options.map { |k, v| [:only, :except].include?(k.to_sym) ? [k, [v].flatten.map(&:to_sym)] : [k, v] }].reverse_merge(only: DynamicController::ACTIONS, except: [])
      send :extend, ClassMethods
      send :include, InstanceMethods
      send :include, HelperMethods
    end

    def nested_of(resource_class)
      before_filter :load_parent_models if parent_resources.empty?
      parent_resources << Resource.new(resource_class: resource_class)
    end

  end
end