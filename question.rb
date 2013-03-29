require_relative 'question_database'
require_relative 'user'
require_relative 'question_answer'
require_relative 'question_follower'
require_relative 'question_like'

class Question

  def self.find_by_id(id)
    result = QDatabase.instance.execute(<<-SQL, id)
      SELECT *
      	FROM questions
       WHERE id = ?
      SQL

    Question.new(result[0]) 
  end

  def self.find_questions(author_id)
  	QDatabase.instance.execute(<<-SQL, author_id)
    	SELECT title
        FROM questions
       WHERE author_id = ?
    SQL
  end

  def self.most_followed(n)
    result = QuestionFollower.most_followers
    result[0...n]
  end

  attr_reader :title, :body, :author_id

  def initialize(result_array=nil)
    @id, @title, @body, @author_id = result_array unless result_array.nil?
  end

  def num_likes 
	  QuestionLike.like_count(@id)
  end

  def self.most_liked(n)
    results = QuestionLike.most_likes
    
    results[0...n]
  end

  def followers(id) 
    QuestionFollower.followers(id)
  end

  def save(title, body, author_id)
    raise "Question already saved in database." if @id

    QDatabase.instance.execute(
      "INSERT INTO questions ('title','body','author_id')
        VALUES (?,?,?)", title, body, author_id)

    @title, @body, @author_id = title, body, author_id
    @id = QDatabase.instance.execute(
      "SELECT MAX(last_insert_rowid()) FROM questions")[0][0]
  end
end