class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :last_access
end
