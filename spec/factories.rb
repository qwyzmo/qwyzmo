

# by using the symbol ':user', we get factory girl to simulate the user model
Factory.define :user do |user|
  user.name                     "Momo Fitzy"
  user.email                    "momo@qwyzmo.com"
  user.password                 "foobar"
  user.password_confirmation    "foobar"
end
  
