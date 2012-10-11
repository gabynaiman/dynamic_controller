class AllActionsController < ActionController::Base
  has_crud_actions
end

class OnlyIndexController < ActionController::Base
  has_crud_actions only: :index
end

class ExceptIndexController < ActionController::Base
  has_crud_actions except: :index
end

class OnlyAndExceptController < ActionController::Base
  has_crud_actions only: [:index, :new, :create, :edit], except: [:edit, :destroy]
end

class XlsResponderController < ActionController::Base
  has_crud_actions

  respond_to_index :xls do
    render xls: nil
  end
end