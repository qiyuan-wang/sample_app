FactoryGirl.define do
  factory :user do
    name   "Tyler"
    email  "tyler@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end
end