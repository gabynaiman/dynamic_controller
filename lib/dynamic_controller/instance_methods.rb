module DynamicController
  module InstanceMethods

    def self.included(base)
      base.send :include, HelperMethods
      base.respond_to :html, :json
      base.rescue_from StandardError, with: :handle_error

      if base.include_action?(:index)
        base.send :define_method, :index do
          if parent_model
            self.collection = parent_model.send(controller_name).search(params[:q]).result.page(params[:page])
          else
            self.collection = resource_class.search(params[:q]).result.page(params[:page])
          end

          respond_with collection
        end
      end

      if base.include_action?(:show)
        base.send :define_method, :show do
          if parent_model
            self.model = parent_model.send(controller_name).find(params[:id])
          else
            self.model = resource_class.find(params[:id])
          end

          respond_with model
        end
      end

      if base.include_action?(:new)
        base.send :define_method, :new do
          if parent_model
            self.model = parent_model.send(controller_name).build
          else
            self.model = resource_class.new
          end
        end
      end

      if base.include_action?(:edit)
        base.send :define_method, :edit do
          if parent_model
            self.model = parent_model.send(controller_name).find(params[:id])
          else
            self.model = resource_class.find(params[:id])
          end
        end
      end

      if base.include_action?(:create)
        base.send :define_method, :create do
          if parent_model
            self.model = parent_model.send(controller_name).build(params[controller_name.singularize])
          else
            self.model = resource_class.new(params[controller_name.singularize])
          end

          if model.save
            flash_message = "#{resource_class.model_name.human} successfully created"
            if params[:save_and_new]
              flash[:success] = flash_message
              redirect_to action: :new
            else
              flash.now[:success] = flash_message
              respond_to do |format|
                format.html { redirect_to action: :show, id: model.id }
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
      end

      if base.include_action?(:update)
        base.send :define_method, :update do
          if parent_model
            self.model = parent_model.send(controller_name).find(params[:id])
          else
            self.model = resource_class.find(params[:id])
          end

          if model.update_attributes(params[controller_name.singularize])
            flash.now[:success] = "#{resource_class.model_name.human} successfully updated"
            respond_to do |format|
              format.html { redirect_to action: :show, id: model.id }
              format.json { head :no_content }
            end
          else
            respond_to do |format|
              format.html { render :edit }
              format.json { render json: model.errors, status: :unprocessable_entity }
            end
          end
        end

      end

      if base.include_action?(:destroy)
        base.send :define_method, :destroy do
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
      end

    end

  end
end