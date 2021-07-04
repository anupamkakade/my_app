# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ApiController, type: :controller do

        describe "GET /root" do
          it 'renders a successful response' do
            allow(ExternalApiCaller).to receive(:call_api).and_return(true)
            get :index
            expect(response).to be_successful
          end
          it 'renders a successful response' do
            allow(ExternalApiCaller).to receive(:call_api).and_raise(Exception)
            get :index
            expect(response).to_not be_successful
          end
        end
end