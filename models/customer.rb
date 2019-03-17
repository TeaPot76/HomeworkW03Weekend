require_relative('../db/sql_runner.rb')


class Customer
  attr_accessor :name, :funds
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end


  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @pfunds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * from customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customer_data = SqlRunner.run(sql)
    return customer_data.map{|customer| Customer.new(customer)}
  end

  def all_movies()
    sql = 'SELECT f.* FROM films f
    INNER JOIN tickets t
    ON t.film_id = f.id
    INNER JOIN customers c
    ON c.id = t.customer_id
    WHERE c.id = $1'
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return film_data.map{|film| Film.new(film)}
  end


  def all_movies_total_cust_name(name)
    sql = 'SELECT SUM(f.price) FROM films f
    INNER JOIN tickets t
    ON t.film_id = f.id
    INNER JOIN customers c
    ON c.id = t.customer_id
    WHERE c.name= $1'
    values = [name]
    return SqlRunner.run(sql, values).first["sum"].to_i
  end

 def buy_ticket(film_name)
  puts "I want to buy ticket for #{film_name} "
  sql =  'SELECT * FROM films WHERE title = $1'
  values = [film_name]
  films_data = SqlRunner.run(sql, values)
  result = films_data.map{|film| Film.new(film)}
  price = result[0].price
  puts "The film cost #{price}"
  puts "I have a #{funds}"
  return @funds - price
 end


def tickets_by_name(name)
  sql ='SELECT COUNT(customer_id) FROM tickets
  INNER JOIN customers
  ON customers.id = tickets.customer_id
  WHERE customers.name = $1 '
  values = [name]
  return SqlRunner.run(sql, values).first['count'].to_i
end





end
