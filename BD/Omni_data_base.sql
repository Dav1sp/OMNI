

DROP SCHEMA IF EXISTS "lbaw2194" CASCADE;

CREATE SCHEMA "lbaw2194";

SET search_path TO "lbaw2194";

CREATE TYPE genre AS ENUM ('Female','Male','Others'); 

CREATE TABLE "country"(
    id_country SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);



CREATE TABLE "users" (
        id_users SERIAL PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        password TEXT NOT NULL,
        photo TEXT NOT NULL DEFAULT '../imgDefault/img.PNG', 
        admin BOOLEAN DEFAULT 'FALSE',
        country INTEGER NOT NULL REFERENCES country(id_country) ON DELETE CASCADE ON UPDATE CASCADE,
        gender genre NOT NULL,
        birthday DATE NOT NULL CHECK (birthday < current_date)
);

CREATE TABLE "users_profile" (
        id_users_profile SERIAL PRIMARY KEY,
        id_users INTEGER NOT NULL REFERENCES users(id_users) ON DELETE CASCADE ON UPDATE CASCADE,
        url TEXT NOT NULL UNIQUE,
        follower_int INTEGER DEFAULT '0' CHECK (follower_int>=0),
        following_int INTEGER DEFAULT '0' CHECK (following_int>=0),
        total_up INTEGER DEFAULT '0' CHECK (total_up >=0),
        total_down INTEGER DEFAULT '0' CHECK (total_down >=0),
        descricao TEXT
);

CREATE TABLE "category" (
    id_category SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE "post" (
    id_post SERIAL PRIMARY KEY,
    id_users INTEGER NOT NULL REFERENCES users(id_users) ON DELETE CASCADE ON UPDATE CASCADE,
    id_category INTEGER NOT NULL REFERENCES category(id_category) ON DELETE CASCADE ON UPDATE CASCADE,
    total_up INTEGER DEFAULT '0' CHECK (total_up >= 0),
    total_down INTEGER DEFAULT '0' CHECK (total_down >= 0),
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL,
    url TEXT NOT NULL UNIQUE,
    media TEXT,
    title TEXT NOT NULL,
    new TEXT NOT NULL
);
CREATE TABLE "comment" (
    id_comment SERIAL PRIMARY KEY,
	id_users INTEGER REFERENCES users(id_users) ON DELETE CASCADE ON UPDATE CASCADE,
    id_post INTEGER REFERENCES post(id_post) ON DELETE CASCADE ON UPDATE CASCADE,
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL,
    comment TEXT NOT NULL,
    total_up INTEGER DEFAULT '0' CHECK (total_up >= 0),
    total_down INTEGER DEFAULT '0' CHECK (total_down >= 0)
);
CREATE TABLE "vote_post" (
    id_vote SERIAL PRIMARY KEY,
    id_users INTEGER REFERENCES users(id_users) ON DELETE CASCADE ON UPDATE CASCADE,
    id_post INTEGER REFERENCES post(id_post) ON DELETE CASCADE ON UPDATE CASCADE,
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL,
    value BOOLEAN NOT NULL /*True up False down*/
);
CREATE TABLE "vote_comment" (
    id_vote SERIAL PRIMARY KEY,
    id_users INTEGER REFERENCES users(id_users) ON DELETE CASCADE ON UPDATE CASCADE,
    id_comment INTEGER REFERENCES comment(id_comment) ON DELETE CASCADE ON UPDATE CASCADE,
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL,
    value BOOLEAN NOT NULL /*True up False down*/
);
CREATE TABLE "favorite"(
    id_users_profile INTEGER REFERENCES users_profile(id_users_profile) ON DELETE CASCADE ON UPDATE CASCADE,
    id_post INTEGER REFERENCES post(id_post) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_users_profile, id_post)
);
CREATE TABLE "repost"(
    id_users_profile INTEGER REFERENCES users_profile(id_users_profile) ON DELETE CASCADE ON UPDATE CASCADE,
    id_post INTEGER REFERENCES post(id_post) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_users_profile, id_post)
);
CREATE TABLE "follow"(
    id_users_follower INTEGER REFERENCES users_profile(id_users_profile) ON DELETE CASCADE ON UPDATE CASCADE,
    id_users_followed INTEGER REFERENCES users_profile(id_users_profile) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_users_follower, id_users_followed)
);
CREATE TABLE "comcom"(
    id_commenter INTEGER REFERENCES comment(id_comment) ON DELETE CASCADE ON UPDATE CASCADE,
    id_commented INTEGER REFERENCES comment(id_comment) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_commenter, id_commented)
);

CREATE TABLE "activity"(
    id_activity SERIAL PRIMARY KEY,
    id_users_profile INTEGER REFERENCES users_profile(id_users_profile) ON DELETE CASCADE ON UPDATE CASCADE,
    log TEXT NOT NULL,
    url TEXT NOT NULL,
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL
);

CREATE TABLE "notification"(
    id_notification SERIAL PRIMARY KEY,
    id_users_profile INTEGER REFERENCES users_profile(id_users_profile) ON DELETE CASCADE ON UPDATE CASCADE,
    log TEXT NOT NULL,
    url TEXT NOT NULL,
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL
);

/*INDEX*/

CREATE INDEX  post_title_idx ON post USING GIST (to_tsvector('english', title));
CREATE INDEX  user_name_idx ON users USING GIST (to_tsvector('english',name));
CREATE INDEX  post_date ON post USING  btree (date);
CREATE INDEX  comment_date ON comment USING  btree (date);

/*TRIGGER*/
/*Actividade post*/
CREATE FUNCTION insert_activity_post() RETURNS TRIGGER AS
$BODY$
DECLARE
    title_post TEXT;                 /*Titulo da noticia*/
    name_user TEXT;                  /*Nome da Pessoa que posta a Noticia*/
    log_entry TEXT;                  /*Entrada no logBook*/
    url_post TEXT;                   /*Url unico da Noticia*/
    id_users_profile_poster INTEGER;   /*Pessoa que posta o Noticia*/
BEGIN

    /*Actividade*/
    SELECT users_profile.id_users_profile INTO id_users_profile_poster FROM users_profile WHERE id_users=NEW.id_users;
    SELECT users.name INTO name_user FROM users WHERE id_users=NEW.id_users;
    title_post = NEW.title;
    log_entry = name_user || ' posted the news "'|| title_post ||'"';
    url_post = NEW.url;
    INSERT INTO activity (id_users_profile,log,url)
    VALUES(id_users_profile_poster,log_entry,url_post);
    RETURN NEW;

END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER insert_activity_post
AFTER INSERT ON post
FOR EACH ROW
EXECUTE PROCEDURE insert_activity_post();

/*Actividade e notificaçao Follow*/
CREATE FUNCTION insert_activity_notification_follow() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
    name_follower TEXT;              /*Nome do follower*/
    name_followed TEXT;              /*Nome do Followed*/
    log_entry TEXT;                  /*Entrada no logBook*/
    url_follow TEXT;               /*Url unico do Followed*/
    id_users_follower_copy INTEGER;    /*Id do follower*/
BEGIN

    /*Actividade*/
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = NEW.id_users_follower;
    SELECT users.name INTO name_follower FROM users WHERE id_users=id_aux;
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = NEW.id_users_followed;
    SELECT users.name INTO name_followed FROM users WHERE id_users=id_aux;
    SELECT users_profile.url INTO url_follow FROM users_profile WHERE id_users_profile = NEW.id_users_followed;
    log_entry = name_follower || ' followed '|| name_followed;
    id_users_follower_copy = NEW.id_users_follower;
    INSERT INTO activity (id_users_profile,log,url)
    VALUES(id_users_follower_copy,log_entry,url_follow);

    /*Notificacao*/
    SELECT users_profile.url INTO url_follow FROM users_profile WHERE id_users_profile = NEW.id_users_follower;
    log_entry = name_follower || ' followed you';
    id_users_follower_copy = NEW.id_users_followed;
    INSERT INTO notification (id_users_profile,log,url)
    VALUES(id_users_follower_copy,log_entry,url_follow);

    /*update total Followed follower*/
    UPDATE users_profile
    SET follower_int = follower_int+1
    WHERE id_users_profile = NEW.id_users_followed;
    UPDATE users_profile
    SET following_int = following_int+1
    WHERE id_users_profile = NEW.id_users_follower;

    RETURN NEW;

END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER insert_activity_notification_follow
AFTER INSERT ON follow
FOR EACH ROW
EXECUTE PROCEDURE insert_activity_notification_follow();

/*Actividade Comment*/
CREATE FUNCTION insert_activity_comment() RETURNS TRIGGER AS
$BODY$
DECLARE
    name_commenter TEXT;                /*Nome do Commenter*/
    title_post TEXT;                    /*Titulo da noticia*/
    log_entry TEXT;                     /*Entrada no logBook*/
    url_post TEXT;                      /*Url unico da Noticia*/
    id_users_profile_commenter INTEGER;   /*Id do Commenter*/
BEGIN
    SELECT users.name INTO name_commenter FROM users WHERE id_users=NEW.id_users;
    SELECT post.title INTO title_post FROM post WHERE id_post=NEW.id_post;
    SELECT post.url INTO url_post FROM post WHERE id_post = NEW.id_post;
    SELECT users_profile.id_users_profile INTO id_users_profile_commenter FROM users_profile WHERE id_users=NEW.id_users;
    log_entry = name_commenter || ' commented on the news "'|| title_post ||'"';
    INSERT INTO activity (id_users_profile,log,url)
    VALUES(id_users_profile_commenter,log_entry,url_post);
    
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER insert_activity_comment
AFTER INSERT ON comment
FOR EACH ROW
EXECUTE PROCEDURE insert_activity_comment();


/*Actividade e notificaçao votePost*/
CREATE FUNCTION insert_activity_notification_update_vote_post() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
    name_voter TEXT;                    /*Nome do Voter*/
    title_post TEXT;                    /*Titulo da noticia*/
    log_entry TEXT;                     /*Entrada no logBook*/
    url_post TEXT;                      /*Url unico da Noticia*/
    id_users_profile_vote INTEGER;   /*Id do Commenter*/
BEGIN
    IF NEW.value = 'TRUE' THEN 
        
        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=NEW.id_users;
        SELECT post.title INTO title_post FROM post WHERE id_post=NEW.id_post;
        SELECT post.url INTO url_post FROM post WHERE id_post = NEW.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=NEW.id_users;
        log_entry = name_voter || ' voted Up on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log,url)
        VALUES(id_users_profile_vote,log_entry,url_post);
       
        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = NEW.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Up in ur news ' || title_post;
        INSERT INTO notification (id_users_profile,log,url)
        VALUES(id_users_profile_vote,log_entry,url_post);

        /*Up Atualizaçao*/
        UPDATE post 
        SET total_up = total_up+1
        WHERE id_post = NEW.id_post;
        UPDATE users_profile
        SET total_up = total_up+1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    IF NEW.value = 'FALSE' THEN 
        
        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=NEW.id_users;
        SELECT post.title INTO title_post FROM post WHERE id_post=NEW.id_post;
        SELECT post.url INTO url_post FROM post WHERE id_post = NEW.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=NEW.id_users;
        log_entry = name_voter || ' voted Down on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log,url)
        VALUES(id_users_profile_vote,log_entry,url_post);

        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = NEW.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Down in ur news ' || title_post;
        INSERT INTO notification (id_users_profile,log,url)
        VALUES(id_users_profile_vote,log_entry,url_post);

        /*Down Atualizaçao*/
        UPDATE post 
        SET total_Down = total_Down+1
        WHERE id_post = NEW.id_post;
        UPDATE users_profile
        SET total_Down = total_Down+1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER insert_activity_notification_update_vote_post
AFTER INSERT ON vote_post
FOR EACH ROW
EXECUTE PROCEDURE insert_activity_notification_update_vote_post();

/*Actividade voteComent*/
CREATE FUNCTION insert_activity_notification_vote_comment() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
    name_voter TEXT;                    /*Nome do Voter*/
    name_commenter TEXT;                /*Nome de quem fez o comentario*/
    title_post TEXT;                    /*Titulo da noticia*/
    log_entry TEXT;                     /*Entrada no logBook*/
    url_post TEXT;                      /*Url unico da Noticia*/
    id_users_profile_vote INTEGER;       /*Id do Commenter*/
BEGIN
    IF NEW.value = 'TRUE' THEN 
        
        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=NEW.id_users;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT comment.id_post INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT post.title INTO title_post FROM post WHERE id_post=id_aux;
        SELECT post.url INTO url_post FROM post WHERE id_post=id_aux;
        id_users_profile_vote = NEW.id_users;
        log_entry = name_voter || ' voted Up on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log,url)
        VALUES(id_users_profile_vote,log_entry,url_post);

        /*Up Atualização*/
        UPDATE comment
        SET total_up = total_up+1
        WHERE id_comment = NEW.id_comment;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        UPDATE users_profile
        SET total_up = total_up+1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    IF NEW.value = 'FALSE' THEN 

        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=NEW.id_users;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT comment.id_post INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT post.title INTO title_post FROM post WHERE id_post=id_aux;
        SELECT post.url INTO url_post FROM post WHERE id_post=id_aux;
        id_users_profile_vote = NEW.id_users;
        log_entry = name_voter || ' voted Down on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log,url)
        VALUES(id_users_profile_vote,log_entry,url_post);
        
        /*notificaçao*/
        /*log_entry = name_voter || ' voted Down in your comment on "'|| title_post ||'" news';
        INSERT INTO notification (id_users_profile,log,url)
        VALUES(id_users_profile_vote,log_entry,url_post);*/

        /*Down Atualização*/
        UPDATE comment
        SET total_down = total_down+1
        WHERE id_comment = NEW.id_comment;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        UPDATE users_profile
        SET total_down = total_down+1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER insert_activity_notification_vote_comment
AFTER INSERT ON vote_comment
FOR EACH ROW
EXECUTE PROCEDURE insert_activity_notification_vote_comment();

CREATE FUNCTION delete_activity_notification_update_vote_post() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
    name_voter TEXT;                    /*Nome do Voter*/
    title_post TEXT;                    /*Titulo da noticia*/
    log_entry TEXT;                     /*Entrada no logBook*/
    url_post TEXT;                      /*Url unico da Noticia*/
    id_users_profile_vote INTEGER;   /*Id do Commenter*/
BEGIN
    IF OLD.value = 'TRUE' THEN 
        
        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=OLD.id_users;
        SELECT post.title INTO title_post FROM post WHERE id_post=OLD.id_post;
        SELECT post.url INTO url_post FROM post WHERE id_post = OLD.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=OLD.id_users;
        log_entry = name_voter || ' voted Up on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry AND url = url_post;
        DELETE FROM activity
        WHERE id_activity = id_aux;
       
        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = OLD.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Up in ur news ' || title_post;
        SELECT notification.id_notification INTO id_aux FROM notification WHERE id_users_profile = id_users_profile_vote AND log = log_entry AND url = url_post;
        DELETE FROM activity
        WHERE id_activity = id_aux;

        /*Up Atualizaçao*/
        UPDATE post 
        SET total_up = total_up-1
        WHERE id_post = OLD.id_post;
        UPDATE users_profile
        SET total_up = total_up-1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    IF OLD.value = 'FALSE' THEN 
        
        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=OLD.id_users;
        SELECT post.title INTO title_post FROM post WHERE id_post=OLD.id_post;
        SELECT post.url INTO url_post FROM post WHERE id_post = OLD.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=OLD.id_users;
        log_entry = name_voter || ' voted Down on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry AND url = url_post;
        DELETE FROM activity
        WHERE id_activity = id_aux;

        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = OLD.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Down in ur news ' || title_post;
        SELECT notification.id_notification INTO id_aux FROM notification WHERE id_users_profile = id_users_profile_vote AND log = log_entry AND url = url_post;
        DELETE FROM activity
        WHERE id_activity = id_aux;

        /*Down Atualizaçao*/
        UPDATE post 
        SET total_Down = total_Down-1
        WHERE id_post = OLD.id_post;
        UPDATE users_profile
        SET total_Down = total_Down-1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    RETURN OLD;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER delete_activity_notification_update_vote_post
AFTER DELETE ON vote_post
FOR EACH ROW
EXECUTE PROCEDURE delete_activity_notification_update_vote_post();

/*Delete comment activity atualiza up e down*/
CREATE FUNCTION delete_activity_notification_update_vote_comment() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
    name_voter TEXT;                    /*Nome do Voter*/
    name_commenter TEXT;                /*Nome de quem fez o comentario*/
    title_post TEXT;                    /*Titulo da noticia*/
    log_entry TEXT;                     /*Entrada no logBook*/
    url_post TEXT;                      /*Url unico da Noticia*/
    id_users_profile_vote INTEGER;       /*Id do Commenter*/
BEGIN
    IF OLD.value = 'TRUE' THEN 
        
        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=OLD.id_users;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT comment.id_post INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT post.title INTO title_post FROM post WHERE id_post=id_aux;
        SELECT post.url INTO url_post FROM post WHERE id_post=id_aux;
        id_users_profile_vote = OLD.id_users;
        log_entry = name_voter || ' voted Up on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry AND url = url_post;
        DELETE FROM activity
        WHERE id_activity = id_aux;

        /*Up Atualização*/
        UPDATE comment
        SET total_up = total_up-1
        WHERE id_comment = OLD.id_comment;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        UPDATE users_profile
        SET total_up = total_up-1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    IF OLD.value = 'FALSE' THEN 

        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=OLD.id_users;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT comment.id_post INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT post.title INTO title_post FROM post WHERE id_post=id_aux;
        SELECT post.url INTO url_post FROM post WHERE id_post=id_aux;
        id_users_profile_vote = OLD.id_users;
        log_entry = name_voter || ' voted Down on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry AND url = url_post;
        DELETE FROM activity
        WHERE id_activity = id_aux;

        /*Down Atualização*/
        UPDATE comment
        SET total_down = total_down-1
        WHERE id_comment = OLD.id_comment;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        UPDATE users_profile
        SET total_down = total_down-1
        WHERE id_users_profile = id_users_profile_vote;

    END IF;
    RETURN OLD;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER delete_activity_notification_update_vote_comment
AFTER DELETE ON vote_comment
FOR EACH ROW
EXECUTE PROCEDURE delete_activity_notification_update_vote_comment();

CREATE FUNCTION delete_post() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
BEGIN
    SELECT post.id_post INTO id_aux FROM post where id_post=NEW.id_post;
    IF EXISTS (SELECT id_comment FROM comment WHERE id_post=id_aux )
    THEN RAISE EXCEPTION 'A post cannot be delete with a comment';
    END IF;

    IF EXISTS (SELECT id_vote FROM vote_post WHERE id_post=id_aux)
    THEN RAISE EXCEPTION 'A post cannot be delete with a vote';
    END IF;

    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER delete_post
BEFORE DELETE ON post 
FOR EACH ROW 
EXECUTE PROCEDURE delete_post();

/*Actividade e notificaçao Follow*/
CREATE FUNCTION delete_activity_notification_follow() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
    name_follower TEXT;              /*Nome do follower*/
    name_followed TEXT;              /*Nome do Followed*/
    log_entry TEXT;                  /*Entrada no logBook*/
    url_follow TEXT;               /*Url unico do Followed*/
    id_users_follower_copy INTEGER;    /*Id do follower*/
BEGIN

    /*Actividade*/
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = OLD.id_users_follower;
    SELECT users.name INTO name_follower FROM users WHERE id_users=id_aux;
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = OLD.id_users_followed;
    SELECT users.name INTO name_followed FROM users WHERE id_users=id_aux;
    SELECT users_profile.url INTO url_follow FROM users_profile WHERE id_users_profile = OLD.id_users_followed;
    log_entry = name_follower || ' followed '|| name_followed;
    id_users_follower_copy = OLD.id_users_follower;
    SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_follower_copy AND log = log_entry AND url = url_follow;
    DELETE FROM activity
    WHERE id_activity = id_aux;

    /*Notificacao*/
    SELECT users_profile.url INTO url_follow FROM users_profile WHERE id_users_profile = OLD.id_users_follower;
    log_entry = name_follower || ' followed you';
    id_users_follower_copy = OLD.id_users_followed;
    SELECT notification.id_notification INTO id_aux FROM notification WHERE id_users_profile = id_users_follower_copy AND log = log_entry AND url = url_follow;
    DELETE FROM notification
    WHERE id_notification = id_aux;

    /*update total Followed follower*/
    UPDATE users_profile
    SET follower_int = follower_int-1
    WHERE id_users_profile = OLD.id_users_followed;
    UPDATE users_profile
    SET following_int = following_int-1
    WHERE id_users_profile = OLD.id_users_follower;

    RETURN OLD;

END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER delete_activity_notification_follow
AFTER DELETE ON follow
FOR EACH ROW
EXECUTE PROCEDURE delete_activity_notification_follow();