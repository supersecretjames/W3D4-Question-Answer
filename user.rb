require_relative 'question_database'
require_relative 'question'
require_relative 'question_answer'

class User

  def self.find_by_id(id)
    result = QDatabase.instance.execute(<<-SQL, id)
      SELECT *
        FROM users
       WHERE id = ?
      SQL

    User.new(*result) 
  end

  def initialize(result_array=nil)
    @id, @fname, @lname, @is_instructor = result_array unless result_array.nil?
  end

  attr_reader :fname, :lname, :is_instructor

  def average_karma
    QDatabase.instance.execute(<<-SQL, @id, @id)
      SELECT users.fname, users.lname, COUNT(question_likes.liker_id) /
         (SELECT COUNT(questions.id)
         FROM questions
        WHERE author_id = ?)
         FROM users
      	 JOIN questions
      	   ON users.id = author_id
      	 JOIN question_likes
      	   ON questions.id = question_id
      	WHERE users.id = ?
 			SQL
  end

  def questions 
    Question.find_questions(@id)
  end

  def replies 
    QuestionAnswer.user_replies(@id)
  end

  def most_karma(n) #Broken during refactoring
    results = QuestionLike.most_karma(@id)
    results[0...n]
  end

  def save(fname, lname)
    raise "user already saved in database." if @id

    QDatabase.instance.execute(
      "INSERT INTO users ('fname','lname','is_instructor')
        VALUES (?,?,0)", fname, lname)

    @fname, @lname = fname, lname
    @id = QDatabase.instance.execute(
      "SELECT MAX(last_insert_rowid()) FROM users")[0][0]
  end
end