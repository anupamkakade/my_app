require 'concurrent'

class ApiController < ApplicationController

    def index
        Rails.logger.info("Index action is called !!");        
        tw_json,fb_json = nil
        twitter_api_promise = Concurrent::Promise.execute do
            tw_json = JSON.parse(ExternalApiCaller.call_api(ENV['TWITTER_URL']))
        end
        facebook_api_promise = Concurrent::Promise.execute do
            fb_json = JSON.parse(ExternalApiCaller.call_api(ENV['FACEBOOK_URL']))
        end
        [twitter_api_promise ,facebook_api_promise].map(&:value!).flatten

        render json: { twitter: tw_json.map{|tw| tw["tweet"]}, facebook: fb_json.map{|tw| tw["status"]}}, status: :ok
        rescue JSON::ParserError => parse_error
            Rails.logger.error("Json Parsing error #{parse_error.message} ")          
            render json: { result: "Unable to parse the json response" }.to_json, status: :unprocessable_entity
        rescue Exception => exception         
            Rails.logger.error("Exception #{exception.message} \n Class #{exception.class} and backtrace #{exception.backtrace} ")
            render json: { result: "Something went wrong. Exception - #{exception.message}" }.to_json, status: :unprocessable_entity
    end

end
