CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  is_instructor INTEGER
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE question_answers (
  question_id INTEGER NOT NULL,
  reply TEXT NOT NULL,
  replier_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (replier_id) REFERENCES users(id)
);

CREATE TABLE question_actions (
  question_id INTEGER NOT NULL,
  type VARCHAR(255),

  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  question_id INTEGER NOT NULL,
  liker_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (liker_id) REFERENCES users(id)
);

INSERT INTO users ('fname', 'lname','is_instructor')
  VALUES ('Steve', 'Li',0), ('James', 'Yu',0), ('Ned', 'Ruggeri',1),
         ('Karl','Childers', 0);

INSERT INTO questions ('title','body','author_id')
  VALUES ('do you like cats?','', 1),
         ('do you hate dogs?','since cats rule', 2),
       ('can someone do a Sling Blade impression?','I like to see that',1);

INSERT INTO question_likes ('question_id', 'liker_id')
  VALUES (1, 1), (1, 2), (1, 3), (2, 2), (1, 4);

INSERT INTO question_followers ('question_id', 'follower_id')
  VALUES (1, 1), (1, 2), (2, 1), (2, 2), (2, 3);

INSERT INTO question_answers ('question_id', 'reply', 'replier_id')
  VALUES (2, 'I have a dog, punk.', 3), (1, 'I hate cats.', 2), (1, 'Yes', 3),
         (3, 'I sure do like them French fried taters.', 4) ;
