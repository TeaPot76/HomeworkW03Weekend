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

end
