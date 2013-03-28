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

  def self.num_likes(question_id)
    QDatabase.instance.execute("SELECT COUNT(liker_id)
                                FROM question_likes
                                WHERE question_id = #{question_id}")
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


