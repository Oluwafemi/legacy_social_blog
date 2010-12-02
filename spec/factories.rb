#By using the symbol ':user', we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                      "Oluwafemi Ade"
  user.email                     "favourfield@gmail.com"
  user.password                  "love_and_grace"
  user.password_confirmation     "love_and_grace"
end

Factory.sequence :email do |n|
  "miraculous-#{n}@turnarounds.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Look! I'm setting a stone in Zion"
  micropost.association :user
end
