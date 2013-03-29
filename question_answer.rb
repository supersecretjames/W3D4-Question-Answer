require_relative 'question_database'
require_relative 'user'
require_relative 'question'

class QuestionAnswer

  def self.find_by_id(id)
    result = QDatabase.instance.execute(<<-SQL, id)
      SELECT *
        FROM question_answers
       WHERE question_id = ?
      SQL

    QuestionAnswer.new(result[0]) 
  end

    def self.user_replies(id)
    QDatabase.instance.execute(<<-SQL, id)
      SELECT reply
        FROM question_answers
       WHERE replier_id = ?
      SQL
  end

  def self.most_replied
    QDatabase.instance.execute(<<-SQL)
      SELECT title, COUNT(reply)
         FROM question_answers
         JOIN questions
           ON question_id = id      
     GROUP BY title
     ORDER BY COUNT(reply) Desc
     SQL
  end

  attr_reader :question_id, :reply, :replier_id

  def initialize(result_array = nil)
    @question_id, @reply, @replier_id = result_array unless result_array.nil?
  end
  
  def replies(question_id)
    QDatabase.instance.execute(<<-SQL, question_id)
      SELECT title, reply, fname, lname
        FROM question_answers
        JOIN users
          ON replier_id = users.id
        JOIN questions
          ON question_id = questions.id
       WHERE question_id = ?
      SQL
  end

  def save(question_id, reply, replier_id)
    QDatabase.instance.execute(
      "INSERT INTO question_answers ('question_id', 'reply', 'replier_id')
        VALUES (?,?,?)", question_id, reply, replier_id)

    @question_id, @reply, @replier_id = question_id, reply, replier_id
  end
end