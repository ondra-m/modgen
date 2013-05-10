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

  resources :dataset do
    get 'list' do
      {
        datasets: [
          {
            id: 1,
            posted_at: Time.now - 5.months,
            analyzed_at: Time.now - 5.months,
            column_count: 3,
            row_count: 4937,
            labels: ["attr 1", "attr 2", "attr 3"]
          },
          {
            id: 2,
            posted_at: Time.now - 6.months,
            analyzed_at: Time.now - 1.months,
            column_count: 3,
            row_count: 1259,
            labels: ["attr 1", "attr 2", "attr 3"]
          },
          {
            id: 3,
            posted_at: Time.now - 6.minutes,
            analyzed_at: Time.now - 5.minutes,
            column_count: 3,
            row_count: 3526,
            labels: ["attr 1", "attr 2", "attr 3"]
          }
        ]
      }
    end

    params do
      requires :id, type: Integer, desc: "Id of dataset."
    end
    get ':id' do
      if params['id'].to_i <= 3
        {
          id: params['id'],
          posted_at: Time.now - 5.months,
          analyzed_at: Time.now - 5.months,
          column_count: 3,
          row_count: 4937,
          labels: ["attr 1", "attr 2", "attr 3"]
        }
      else
        throw :error, status: 404, message: "Dataset id #{params['id']} doesnt exist."
      end
    end
  end

end
