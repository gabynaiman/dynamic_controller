module DynamicController
  module InstanceMethods

    def self.included(base)
      base.rescue_from StandardError, with: :handle_error

      if base.include_action?(:index)
        base.send :define_method, :index do
          if parent_model
            model = parent_model.send(controller_name)
          else
            model = resource_class
          end

          if search_query_valid?
            self.collection = model.search(search_query).result(distinct: true).page(params[:page])
          else
            self.collection = model.where('1=2').page(params[:page])
          end

          Responder.new(self).index
        end
      end

      if base.include_action?(:show)
        base.send :define_method, :show do
          if parent_model
            self.model = parent_model.send(controller_name).find(params[:id])
          else
            self.model = resource_class.find(params[:id])
          end

          Responder.new(self).show
        end
      end

      if base.include_action?(:new)
        base.send :define_method, :new do
          if parent_model
            self.model = parent_model.send(controller_name).build
          else
            self.model = resource_class.new
          end

          Responder.new(self).new
        end
      end

      if base.include_action?(:edit)
        base.send :define_method, :edit do
          if parent_model
            self.model = parent_model.send(controller_name).find(params[:id])
          else
            self.model = resource_class.find(params[:id])
          end

          Responder.new(self).edit
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
              Responder.new(self).create
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
            Responder.new(self).update
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
            Responder.new(self).destroy
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