class Modgen::API < Grape::API

  version 'v1', using: :path
  format :json

  helpers do
    def current_user
      @current_user ||= User.last
    end
  end

  before do
    authenticate!
  end

  resources :profile do
    get do
      {
        id: current_user.id,
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email,
        created_at: current_user.created_at,
        updated_at: current_user.updated_at,
        last_access: current_user.last_access
      }
    end

    params do
      requires :user, desc: "Your values to update."
    end
    put do
      current_user.update_attributes(params['user'])

      {
        id: current_user.id,
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email,
        created_at: current_user.created_at,
        updated_at: current_user.updated_at,
        last_access: current_user.last_access
      }
    end
  end

end
