module DynamicController
  class Responder

    def initialize(controller)
      @controller = controller
    end

    def index
      action :index,
             html: Proc.new {},
             json: Proc.new { render json: collection }
    end

    def show
      action :show,
             html: Proc.new {},
             json: Proc.new { render json: model }
    end

    def new
      action :new,
             html: Proc.new {}
    end

    def edit
      action :edit,
             html: Proc.new {}
    end

    def create
      action :create,
             html: Proc.new { redirect_to action: :show, id: model.id },
             json: Proc.new { render json: model, status: :created }
    end

    def update
      action :update,
             html: Proc.new { redirect_to action: :show, id: model.id },
             json: Proc.new { head :no_content }
    end

    def destroy
      action :destroy,
             html: Proc.new { redirect_to action: :index },
             json: Proc.new { head :no_content }
    end

    private

    def action(name, blocks={})
      @controller.instance_eval do
        if self.class.redefined_responder_to?(name)
          respond_to do |format|
            self.instance_exec format, &self.class.redefined_responder_to(name)
          end
        else
          respond_to do |format|
            self.class.responder_formats.each do |mime|
              if self.class.redefined_responder_to?(name, mime)
                format.send(mime) { self.instance_eval &self.class.redefined_responder_to(name, mime) }
              elsif blocks[mime]
                format.send(mime) { self.instance_eval &blocks[mime] }
              end
            end
          end
        end
      end
    end

  end
end