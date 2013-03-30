module ModgenTest
  class APIDiscovery < Grape::API

    format :json

    resource :discovery do
      get :versions do
        MultiJson.load File.read("files/discovery/versions.json")
      end

      get "version/:id" do
        begin
          MultiJson.load File.read("files/discovery/version/#{params[:id]}.json")
        rescue Errno::ENOENT
          throw :error, status: 404, message: "Version #{params[:id]} doesnt exists."
        end
      end
    end

  end
end
