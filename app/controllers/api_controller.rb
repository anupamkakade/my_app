class ApiController < ApplicationController

    def index
        Rails.logger.info("Index action is called !!");    
        twitter_api = "https://takehome.io/twitter"
        facebook_api = "https://takehome.io/facebook"
        twitter_response = ExternalApiCaller.call_api(twitter_api)
        facebook_response = ExternalApiCaller.call_api(facebook_api)
        render json: { twitter: twitter_response, facebook: facebook_response}, status: :ok
        rescue Exception => exception
            Rails.logger.error("Exception #{exception.message} \n and backtrace #{exception.backtrace}")
            render json: { result: "Something went wrong. Exception - #{exception.message}" }.to_json, status: :unprocessable_entity
    end

end
