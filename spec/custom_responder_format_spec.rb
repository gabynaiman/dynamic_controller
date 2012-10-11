require 'spec_helper'

describe 'Custom responder format' do

  it 'Respond only to HTML and JSON' do
    AllActionsController.responder_formats.should eq [:html, :json]
  end

  it 'Respond to XLS' do
    XlsResponderController.responder_formats.should eq [:html, :json, :xls]
  end

end