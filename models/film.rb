require_relative('../db/sql_runner.rb')


class Film
  attr_accessor :title, :price
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end


def save()
  sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
  values = [@title, @price]
  film = SqlRunner.run(sql, values).first
  @id = film['id'].to_i
end


def update()
  sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
  values = [@title, @price, @id]
  SqlRunner.run(sql, values)
end

def delete()
  sql = "DELETE * from films where id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

def self.all()
  sql = "SELECT * FROM films"
  films_data = SqlRunner.run(sql)
  return films_data.map{|film| Film.new(film)}
end

def all_customers()
  sql = ' SELECT c.* FROM customers c
    INNER JOIN tickets t
    ON t.customer_id = c.id
    INNER JOIN films f
    ON f.id = t.film_id
    WHERE f.id = $1'
  values = [@id]
  customer_data = SqlRunner.run(sql, values)
  return customer_data.map{|customer| Customer.new(customer)}
end

def film_by_name(film_name)
  sql =  'SELECT f.* FROM films f
    WHERE f.title = $1'
    values = [film_name]
    films_data = SqlRunner.run(sql, values)
    return films_data.map{|film| Film.new(film)}
end

def tickets
  sql = " SELECT * FROM tickets t
  INNER JOIN films f
  ON f.id = t.film_id
  WHERE  f.title = $1"
  values = [@title]
  tickets = SqlRunner.run(sql, values)
  result = tickets.map{|ticket| Ticket.new(ticket)}
  return result.sum
end


def customers_t()
  sql = 'SELECT COUNT(customer_id) FROM tickets
  INNER JOIN films
  ON films.id = tickets.film_id
  WHERE films.title = $1'
  values = [@title]
  return SqlRunner.run(sql, values).first['count'].to_i
end

def customers_i()
  sql = 'SELECT COUNT(customer_id) FROM tickets
  INNER JOIN films
  ON films.id = tickets.film_id
  WHERE films.id = $1'
  values = [@id]
  return SqlRunner.run(sql, values).first['count'].to_i
end


end
