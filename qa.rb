require 'singleton'
require 'sqlite3'

class QDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("qa.db")
  end
end



class User

  attr_accessor :fname, :lname, :is_instructor

  def self.find_by_id(id)
    result = QDatabase.instance.execute(
      "SELECT *
      FROM users
      WHERE id = ?", id)

    User.new(result[0])
  end

  def initialize(result_array=nil)
    @id, @fname, @lname, @is_instructor = result_array unless result_array.nil?
  end

  def average_karma
    result = QDatabase.instance.execute(
      "SELECT users.fname, users.lname, COUNT(question_likes.liker_id) /
         (SELECT COUNT(questions.id)
          FROM questions
          WHERE author_id = ?)
      FROM users
      JOIN questions
      ON users.id = author_id
      JOIN question_likes
      ON questions.id = question_id
      WHERE users.id = ?", id, id)
      p "#{result[0][0]} #{result[0][1]} has #{result[0][2]} average karma."
  end

  def questions
    results = QDatabase.instance.execute(
    "SELECT title
     FROM questions
     WHERE author_id = ?",id)

     results.each do |result|
       p result[0]
     end
     return nil
  end

  def replies
    results = QDatabase.instance.execute(
      "SELECT reply
       FROM question_answers
       WHERE replier_id = ?",id)

    results.each do |result|
      p result[0]
    end
    return nil
  end

  def save(fname, lname)
    QDatabase.instance.execute(
      "INSERT INTO users ('fname','lname','is_instructor')
        VALUES (?,?,0)", fname, lname)

    @fname, @lname = fname, lname
    @id = QDatabase.instance.execute(
      "SELECT MAX(last_insert_rowid()) FROM users")[0][0]
  end

end

class Question

  attr_accessor :title, :body, :author_id

  def self.find_by_id(id)
    result = QDatabase.instance.execute(
      "SELECT *
      FROM questions
      WHERE id = ?", id)

    Question.new(result[0]) # returns a temp question object
  end

  def self.most_followed(n)

    result = QDatabase.instance.execute(
      "SELECT title, COUNT(follower_id)
      FROM questions JOIN question_followers
      ON id = question_id
      GROUP BY question_id
      ORDER BY COUNT(follower_id) Desc")

    result[0...n].each do |question|
      p "'#{question[0]}' has #{question[1]} followers."
    end

    return nil
  end

  def initialize(result_array=nil)
    @id, @title, @body, @author_id = result_array unless result_array.nil?
  end

  def num_likes
    QDatabase.instance.execute(
      "SELECT COUNT(liker_id)
      FROM question_likes
      WHERE question_id = ?", id)
  end

  def self.most_liked(n)
    results = QDatabase.instance.execute(
      "SELECT question_id, COUNT(liker_id)
      FROM question_likes
      GROUP BY question_id
      ORDER BY COUNT(liker_id) Desc")

    results[0...n]
  end

  def followers
    result = QDatabase.instance.execute(
      "SELECT fname, lname
      FROM question_followers JOIN users
      ON follower_id = id
      WHERE question_id = ?", id)

    result.each do |person|
      p "#{person[0]} #{person[1]}"
    end
    return nil
  end

  def save(title, body, author_id)
    QDatabase.instance.execute(
      "INSERT INTO questions ('title','body','author_id')
        VALUES (?,?,?)", title, body, author_id)

    @title, @body, @author_id = title, body, author_id
    @id = QDatabase.instance.execute(
      "SELECT MAX(last_insert_rowid()) FROM questions")[0][0]
  end

end



class QuestionAnswer

  attr_accessor :question_id, :reply, :replier_id

  def self.find_by_id(id)
    result = QDatabase.instance.execute(
      "SELECT *
      FROM question_answers
      WHERE question_id = ?", id)
    QuestionAnswer.new(result[0]) # returns a temp question object
  end

  def self.most_replied

    results = QDatabase.instance.execute(
      "SELECT title, COUNT(reply)
      FROM question_answers
      JOIN questions
      ON question_id = id
      GROUP BY title
      ORDER BY COUNT(reply) Desc")

    "Question '#{results[0][0]}' has the most replies with #{results[0][1]}."
  end

  def initialize(result_array = nil)
    @question_id, @reply, @replier_id = result_array unless result_array.nil?
  end

  def replies
    result = QDatabase.instance.execute(
      "SELECT title, reply, fname, lname
      FROM question_answers
      JOIN users
      ON replier_id = users.id
      JOIN questions
      ON question_id = questions.id
      WHERE question_id = ?", question_id)

   puts "Question: #{result[0][0]}"
   result.each do |result|
     p "'#{result[1]}' said #{result[2]} #{result[3]}"
   end
   return nil
  end

  def save(question_id, reply, replier_id)
    QDatabase.instance.execute(
      "INSERT INTO question_answers ('question_id', 'reply', 'replier_id')
        VALUES (?,?,?)", question_id, reply, replier_id)

    @question_id, @reply, @replier_id = question_id, reply, replier_id
  end

end


class Question_Like

end

class Question_Action

end

class Question_Follower

end


