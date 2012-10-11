module DynamicController
  module ClassMethods

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

    def responder_formats
      @responder_formats ||= [:html, :json]
    end

    DynamicController::ACTIONS.each do |action|
      define_method "respond_to_#{action}" do |format=nil, &block|
        responder_formats << format if format and !responder_formats.include?(format)
        redefined_responders[redefined_responder_key(action, format)] = block
      end
    end

    private

    def redefined_responder_key(action, format=nil)
      [action, format].compact.join('_').to_sym
    end

  end
end