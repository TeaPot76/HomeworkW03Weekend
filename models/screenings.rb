require_relative('../db/sql_runner.rb')



class Screenings
  attr_reader :id
  attr_accessor :screening_time, :film_id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @screening_time = options['screening_time']
    @film_id = options['film_id'].to_i
  end


  def save()
    sql = "INSERT INTO screenings (screening_time, film_id)
    VALUES ($1, $2) RETURNING id"
    values = [@screening_time, @film_id]
    screenings = SqlRunner.run(sql, values)[0];
    @id = screenings['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (screening_time, film_id) = ($1, $2) WHERE id = $3"
    values = [@screening_time, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * FROM screenings where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screening_data = SqlRunner.run(sql)
    return screening_data.map{|screen| Screenings.new(screen)}
  end

  def total_screenings_by_time()
    sql = 'SELECT screening_time, Count(screening_time)
    FROM screenings
    GROUP BY screening_time'
    p screening_data = SqlRunner.run(sql).first
    return screening_data['count']
  end

  def most_popular_time(film_id)
    sql = 'SELECT COUNT(s.screening_time), s.screening_time FROM films f, screenings s, tickets t
    WHERE f.id = s.film_id and f.id = t.film_id and t.film_id = $1
    GROUP BY s.screening_time ORDER BY COUNT(s.screening_time) DESC
    LIMIT 1'
    values = [film_id]
    screening_data = SqlRunner.run(sql, values)
    return screening_data.first["screening_time"]

  end

  def number_of_tickets(id)
    sql = 'SELECT s.*, COUNT(t.film_id) AS number_of_tickets
      FROM screenings s
      LEFT JOIN tickets t
      ON s.id = t.film_id
      WHERE s.film_id = $1
      GROUP BY s.id
      ORDER BY number_of_tickets DESC'
      values = [id]
      result = SqlRunner.run(sql, values).first
      p Ticket.new(result)
      return result['number_of_tickets'].to_i

    end

    def max_number_of_tickets(id)
      max_number_of_tickets = []
      result = number_of_tickets(id)
      max_number = result.reduce{|x| (x+x) <= 50}
      return max_number
    end



end
