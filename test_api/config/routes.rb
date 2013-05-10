require File.expand_path('../../app/api/api', __FILE__)

TestApi::Application.routes.draw do
  mount Modgen::API => '/api'
end
