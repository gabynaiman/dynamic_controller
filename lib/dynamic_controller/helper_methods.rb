module DynamicController
  module HelperMethods

    def resource_class
      @resource_class ||= (resource_namespace.to_s.split('::') << controller_name.classify).join('::').constantize
    end

    def resource_namespace
      self.class.to_s.deconstantize.constantize
    end

    def collection=(value)
      instance_variable_set("@#{controller_name}", value)
    end

    def collection
      instance_variable_get("@#{controller_name}")
    end

    def model=(value)
      instance_variable_set("@#{controller_name.singularize}", value)
    end

    def model
      instance_variable_get("@#{controller_name.singularize}")
    end

    def load_parent_models
      parent = nil
      self.class.parent_resources.each do |resource|
        if parent
          parent = parent.send(resource.children_name).find(params[resource.param_name])
        else
          parent = resource.find params[resource.param_name]
        end
        instance_variable_set resource.instance_variable_name, parent
      end
    end

    def parent_models
      return nil if self.class.parent_resources.empty?
      self.class.parent_resources.map do |resource|
        instance_variable_get resource.instance_variable_name
      end
    end

    def parent_model
      (parent_models || []).last
    end

    def handle_error(error)
      Rails.logger.error error

      respond_to do |format|
        format.html { raise error }
        format.json { render json: error.message, status: :internal_server_error }
      end
    end

    def model_extended_attributes
      resource_class.column_names | resource_class.reflections.map { |k, v| v.klass.column_names.map { |c| "#{k}_#{c}" } }.flatten
    end

    def search_query
      return @search_query if @search_query

      query_key = "query_#{params[:controller]}_#{params[:action]}"

      @search_query = if params.has_key?(:q)
                        session[query_key] = params[:q] if params[:q_persistent] == 'true'
                        params[:q]
                      else
                        session[query_key]
                      end
    end

  end
end