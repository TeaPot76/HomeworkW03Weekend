
require_relative('./models/film.rb')
require_relative('./models/customer.rb')
require_relative('./models/ticket.rb')
require_relative('./models/screenings.rb')
require_relative('./db/sql_runner.rb')

require('pry-byebug')
film1 = Film.new({'title' => 'Iron Man', 'price' => 20})
# film1.save
film2 = Film.new({'title' => 'Thor', 'price' => 21})
 # film2.save
film3 = Film.new({'title' => 'Captain America', 'price' => 18})
# film3.save
film4 = Film.new({'title' => 'Avengers', 'price' => 22})
# film4.save

customer1 = Customer.new({'name' => 'Dan', 'funds' => 100})
# customer1.save
customer2 = Customer.new({'name' => 'Lidek', 'funds' => 50})
# customer2.save
customer3 = Customer.new({'name' => 'Eddie', 'funds' => 200})
# customer3.save
customer4 = Customer.new({'name' => 'Zita', 'funds' => 100})
# customer4.save

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
 # ticket1.save
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film2.id})
# ticket2.save
ticket3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film2.id})
# ticket3.save
ticket4 = Ticket.new({'customer_id' => customer4.id, 'film_id' => film1.id})
# ticket4.save
ticket5 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film3.id})
# ticket5.save
ticket6 = Ticket.new({'customer_id' => customer4.id, 'film_id' => film4.id})
# ticket6.save
# customer1.buy_ticket('Thor')

screenings1 = Screenings.new({'screening_time' => '19.15', 'film_id' => film4.id})
# screenings1.save
screenings2 = Screenings.new({'screening_time' => '21.15', 'film_id' => film3.id})
 # screenings2.save
screenings3 = Screenings.new({'screening_time' => '17.15', 'film_id' => film3.id})
# screenings3.save

binding.pry
nil
