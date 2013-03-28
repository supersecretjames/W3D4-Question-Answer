require 'singleton'
require 'sqlite3'

class QDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("qa.db")
  end

  def get_users()
    User.instance.execute("SELECT * FROM users")
  end

end

class User

  def self.find_by_id(user_id)
    # returns first and last name
    QDatabase.instance.execute("SELECT fname, lname FROM
    users WHERE id = #{user_id}")
  end

end

class Question

  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    result = QDatabase.instance.execute("SELECT *
                                FROM questions
                                WHERE id = ?", id)
    Question.new(result[0]) # returns a temp question object
  end

  def initialize(result_array)
    @id, @title, @body, @author_id = result_array
  end

  def num_likes
    QDatabase.instance.execute("SELECT COUNT(liker_id)
                                FROM question_likes
                                WHERE question_id = ?", id)
  end

  def self.most_liked(n)
    results = QDatabase.instance.execute("SELECT question_id, COUNT(liker_id)
                                FROM question_likes
                                GROUP BY question_id
                                ORDER BY COUNT(liker_id) Desc")
    results[0...n]
  end

  def followers
    QDatabase.instance.execute("SELECT user_id
                                FROM question_followers
                                WHERE question_id = ?", id)

  end

end

class Question_Like

end

class Question_Action

end

class Question_Follower

end

class Question_Reply

end


