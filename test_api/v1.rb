module ModgenTest
  class APIv1 < Grape::API

    format :json

    resource :dataset do
      get ":id" do
        if params[:id].to_i < 5
          {
            name: "dataset #{params[:id]}",
            created_at: "16012013"
          }
        else
          throw :error, status: 404, message: "Dataset with id: #{params[:id]} doesnt exist"
        end
      end
    end
    
  end
end
