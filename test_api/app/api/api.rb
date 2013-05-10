# require_relative 'group'
# require_relative 'dataset_profile'

module Modgen
  class API < Grape::API

    format :json

    helpers do
      def authenticate!
        puts headers
        error!('401 Unauthorized', 401) unless headers['Api-Key'] == 'f0ddaaef2903e6f2ac634e7f6037c9b2'
      end
    end

    resource :discovery do
      get :versions do
        MultiJson.load File.read("#{Rails.root}/app/api/files/versions.json")
      end

      get "version/:id" do
        begin
          MultiJson.load File.read("#{Rails.root}/app/api/files/version_#{params[:id]}.json")
        rescue Errno::ENOENT
          throw :error, status: 404, message: "Version #{params[:id]} doesnt exists."
        end
      end
    end

  end
end

require_relative 'profile'
require_relative 'dataset'
