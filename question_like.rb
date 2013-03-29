require_relative 'question_database'
require_relative 'user'
require_relative 'question'

class QuestionLike

	def self.most_likes
		QDatabase.instance.execute(<<-SQL)
 	     SELECT question_id, COUNT(liker_id)
 	       FROM question_likes
 	   GROUP BY question_id
 	   ORDER BY COUNT(liker_id) Desc
 	   SQL
	end

	def self.like_count(id)
	 QDatabase.instance.execute(<<-SQL, id)
      SELECT COUNT(liker_id)
        FROM question_likes
     	 WHERE question_id = ?
     	SQL
	end

	def self.most_karma(user_id) #Broken during refactoring. 
		QDatabase.instance.execute(<<-SQL, id)
    	SELECT title, COUNT(liker_id)
        FROM question_likes
      	JOIN questions
      		ON question_id = id
       WHERE author_id = user_id
    GROUP BY question_id
    ORDER BY COUNT(liker_id) Desc
    SQL
	end
end