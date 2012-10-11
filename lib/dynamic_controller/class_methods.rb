module DynamicController
  module ClassMethods
    ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]

    def has_crud_actions(options={})
      @resource_options = Hash[options.map { |k, v| [:only, :except].include?(k.to_sym) ? [k, [v].flatten.map(&:to_sym)] : [k, v] }].reverse_merge(only: ACTIONS, except: [])
      send :include, InstanceMethods
    end

    def nested_of(resource_class)
      before_filter :load_parent_models if parent_resources.empty?
      self.parent_resources << Resource.new(resource_class: resource_class)
    end

    def parent_resources
      @parent_resources ||= []
    end

    def include_action?(action_name)
      (@resource_options[:only] - @resource_options[:except]).include?(action_name)
    end

    def redefined_responders
      @redefined_responders ||= {}
    end

    def redefined_responder_to(action, format=nil)
      redefined_responders[redefined_responder_key(action, format)]
    end

    def redefined_responder_to?(action, format=nil)
      redefined_responders.has_key? redefined_responder_key(action, format)
    end

    ACTIONS.each do |action|
      define_method "respond_to_#{action}" do |format=nil, &block|
        redefined_responders[redefined_responder_key(action, format)] = block
      end
    end

    private

    def redefined_responder_key(action, format=nil)
      [action, format].compact.join('_').to_sym
    end

  end
end