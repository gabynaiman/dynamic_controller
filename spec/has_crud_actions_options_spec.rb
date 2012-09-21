require 'spec_helper'

describe 'Crud actions options' do

  it 'Respond to all actions' do
    controller = AllActionsController.new

    controller.should respond_to :index
    controller.should respond_to :new
    controller.should respond_to :edit
    controller.should respond_to :create
    controller.should respond_to :update
    controller.should respond_to :destroy
  end

  it 'Respond only to index action' do
    controller = OnlyIndexController.new
    
    controller.should respond_to :index
    controller.should_not respond_to :new
    controller.should_not respond_to :edit
    controller.should_not respond_to :create
    controller.should_not respond_to :update
    controller.should_not respond_to :destroy
  end

  it 'Respond to all actions except index' do
    controller = ExceptIndexController.new
    
    controller.should_not respond_to :index
    controller.should respond_to :new
    controller.should respond_to :edit
    controller.should respond_to :create
    controller.should respond_to :update
    controller.should respond_to :destroy
  end

  it 'Respond to combination actions' do
    controller = OnlyAndExceptController.new

    controller.should respond_to :index
    controller.should respond_to :new
    controller.should_not respond_to :edit
    controller.should respond_to :create
    controller.should_not respond_to :update
    controller.should_not respond_to :destroy
  end

end