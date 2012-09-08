require 'dynamic_controller/version'
require 'ransack'
require 'kaminari'

module DynamicController

  module ClassMethods

    attr_reader :dynamic_options

    def has_crud_actions(options={})
      send :include, CrudActions
      before_filter :load_nested if options[:nested_of]
      @dynamic_options = options
    end

  end

  module CrudActions

    def self.included(base)
      base.helper_method [:resource_class, :controller_namespace]
      base.respond_to :html, :json
      base.rescue_from StandardError, with: :handle_error
    end

    def index
      if parent_model
        self.collection = parent_model.send(controller_name).search(params[:q]).result.page(params[:page])
      else
        self.collection = resource_class.search(params[:q]).result.page(params[:page])
      end

      respond_with collection
    end

    def show
      if parent_model
        self.model = parent_model.send(controller_name).find(params[:id])
      else
        self.model = resource_class.find(params[:id])
      end

      respond_with model
    end

    def new
      if parent_model
        self.model = parent_model.send(controller_name).build
      else
        self.model = resource_class.new
      end
    end

    def edit
      if parent_model
        self.model = parent_model.send(controller_name).find(params[:id])
      else
        self.model = resource_class.find(params[:id])
      end
    end

    def create
      if parent_model
        self.model = parent_model.send(controller_name).build(params[resource_class.model_name.underscore])
      else
        self.model = resource_class.new(params[resource_class.model_name.underscore])
      end

      if model.save
        flash_message = "#{resource_class.model_name.human} successfully created"
        if params[:save_and_new]
          flash[:success] = flash_message
          redirect_to action: :new
        else
          flash.now[:success] = flash_message
          respond_to do |format|
            format.html { redirect_to url_for([parent_model, model].compact) }
            format.json { render json: model, status: :created }
          end
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: model.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      if parent_model
        self.model = parent_model.send(controller_name).find(params[:id])
      else
        self.model = resource_class.find(params[:id])
      end

      if model.update_attributes(params[resource_class.model_name.underscore])
        flash.now[:success] = "#{resource_class.model_name.human} successfully updated"
        respond_to do |format|
          format.html { redirect_to url_for([parent_model, model].compact) }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: model.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if parent_model
        self.model = parent_model.send(controller_name).find(params[:id])
      else
        self.model = resource_class.find(params[:id])
      end

      if model.destroy
        flash[:warning] = "#{resource_class.model_name.human} successfully removed"
        respond_to do |format|
          format.html { redirect_to action: :index }
          format.json { head :no_content }
        end
      else
        flash[:danger] = "#{resource_class.model_name.human} could not be deleted"
        respond_to do |format|
          format.html { redirect_to action: :index }
          format.json { render json: model.errors, status: :unprocessable_entity }
        end
      end
    end

    def resource_class
      @resource_class ||= controller_name.classify.constantize
    end

    def controller_namespace
      @controller_namespace ||= self.class.name.split('::')[0..-2].map(&:underscore).join('_') unless self.class.name.split('::')[0..-2].empty?
    end

    private

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

    def load_nested
      parent_klass = self.class.dynamic_options[:nested_of]
      instance_variable_set("@#{parent_klass.to_s.underscore}", parent_klass.find(params["#{parent_klass.to_s.underscore}_id"]))
    end

    def parent_model
      instance_variable_get("@#{self.class.dynamic_options[:nested_of].to_s.underscore}")
    end

    def handle_error(error)
      respond_to do |format|
        format.html { raise error }
        format.json { render json: error.message, status: :internal_server_error }
      end
    end

  end

end

ActionController::Base.send :extend, DynamicController::ClassMethods

