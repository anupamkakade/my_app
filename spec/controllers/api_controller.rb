# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ApiController, type: :controller do

        describe "GET /root" do
          it 'renders a successful response' do
            # Better solution is to use vcr cassets
            tw_json = [
                {
                "username": "test_user1",
                "tweet": "test1"
                },
                {
                "username": "test_user2",
                "tweet": "test2"
                },
                ] 
            fb_json = [
                {
                "name": "Some Friend",
                "status": "Some status"
                },
                {
                "name": "Some Friend1",
                "status": "Some status 2"
                }
                ]
            stub_request(:get, "https://takehome.io/facebook").to_return(status: 200, body: fb_json.to_json)
            stub_request(:get, "https://takehome.io/twitter").to_return(status: 200, body: tw_json.to_json)             
            get :index
            expect(response).to be_successful
          end
          it 'renders a message when some error occurs' do
            allow(ExternalApiCaller).to receive(:call_api).and_raise(Exception)
            get :index
            expect(response).to_not be_successful
          end
          it 'renders a message when some error occurs' do
            allow(ExternalApiCaller).to receive(:call_api).and_raise(JSON::ParserError)
            get :index
            expect(response).to_not be_successful
          end
        end
end