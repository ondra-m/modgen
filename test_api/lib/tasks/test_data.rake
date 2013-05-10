def create_user
  User.create! email: "test#{rand(10)}@test.test",
               first_name: "Firstname #{rand(10)}",
               last_name: "Lastname #{rand(10)}",
               last_access: Time.now.to_i.to_s
end

desc "Create test data"
task :test_data => :environment do
  create_user
end
