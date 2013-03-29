require_relative 'question_database'
require_relative 'user'
require_relative 'question'

class QuestionFollower

	def self.followers(id)
		QDatabase.instance.execute(<<-SQL, id)
    	SELECT fname, lname
    	  FROM question_followers JOIN users
    		  ON follower_id = id
       WHERE question_id = ?
      SQL
	end

	def self.most_followers
		QDatabase.instance.execute(<<-SQL)
        SELECT title, COUNT(follower_id)
       	  FROM questions JOIN question_followers
            ON id = question_id
      GROUP BY question_id
      ORDER BY COUNT(follower_id) Desc
      SQL
	end
end