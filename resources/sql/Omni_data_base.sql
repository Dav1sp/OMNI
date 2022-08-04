

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
        photo TEXT NOT NULL DEFAULT '../img/icons/user.png',
        admin BOOLEAN DEFAULT 'FALSE',
        country INTEGER NOT NULL REFERENCES country(id_country) ON DELETE CASCADE ON UPDATE CASCADE,
        gender genre NOT NULL,
        birthday DATE NOT NULL CHECK (birthday < current_date)
);



CREATE TABLE "users_profile" (
        id_users_profile SERIAL PRIMARY KEY,
        id_users INTEGER NOT NULL REFERENCES users(id_users) ON DELETE CASCADE ON UPDATE CASCADE,
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
    url TEXT,
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
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL
);

CREATE TABLE "notification"(
    id_notification SERIAL PRIMARY KEY,
    id_users_profile INTEGER REFERENCES users_profile(id_users_profile) ON DELETE CASCADE ON UPDATE CASCADE,
    log TEXT NOT NULL,
    date TIMESTAMP WITH TIME ZONE DEFAULT now () NOT NULL
);

CREATE TABLE "contact"(
    id_contact SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    assunto TEXT NOT NULL,
    pergunta TEXT NOT NULL
);

CREATE TABLE "help"(
    id_help SERIAL PRIMARY KEY,
    ideia TEXT NOT NULL
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
    id_users_profile_poster INTEGER;   /*Pessoa que posta o Noticia*/
BEGIN

    /*Actividade*/
    SELECT users_profile.id_users_profile INTO id_users_profile_poster FROM users_profile WHERE id_users=NEW.id_users;
    SELECT users.name INTO name_user FROM users WHERE id_users=NEW.id_users;
    title_post = NEW.title;
    log_entry = name_user || ' posted the news "'|| title_post ||'"';
    INSERT INTO activity (id_users_profile,log)
    VALUES(id_users_profile_poster,log_entry);
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
    id_users_follower_copy INTEGER;    /*Id do follower*/
BEGIN

    /*Actividade*/
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = NEW.id_users_follower;
    SELECT users.name INTO name_follower FROM users WHERE id_users=id_aux;
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = NEW.id_users_followed;
    SELECT users.name INTO name_followed FROM users WHERE id_users=id_aux;
    log_entry = name_follower || ' followed '|| name_followed;
    id_users_follower_copy = NEW.id_users_follower;
    INSERT INTO activity (id_users_profile,log)
    VALUES(id_users_follower_copy,log_entry);

    /*Notificacao*/
    log_entry = name_follower || ' followed you';
    id_users_follower_copy = NEW.id_users_followed;
    INSERT INTO notification (id_users_profile,log)
    VALUES(id_users_follower_copy,log_entry);

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
    id_users_profile_commenter INTEGER;   /*Id do Commenter*/
BEGIN
    SELECT users.name INTO name_commenter FROM users WHERE id_users=NEW.id_users;
    SELECT post.title INTO title_post FROM post WHERE id_post=NEW.id_post;
    SELECT users_profile.id_users_profile INTO id_users_profile_commenter FROM users_profile WHERE id_users=NEW.id_users;
    log_entry = name_commenter || ' commented on the news "'|| title_post ||'"';
    INSERT INTO activity (id_users_profile,log)
    VALUES(id_users_profile_commenter,log_entry);

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
    id_users_profile_vote INTEGER;   /*Id do Commenter*/
BEGIN
    IF NEW.value = 'TRUE' THEN

        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=NEW.id_users;
        SELECT post.title INTO title_post FROM post WHERE id_post=NEW.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=NEW.id_users;
        log_entry = name_voter || ' voted Up on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log)
        VALUES(id_users_profile_vote,log_entry);

        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = NEW.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Up in ur news ' || title_post;
        INSERT INTO notification (id_users_profile,log)
        VALUES(id_users_profile_vote,log_entry);

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
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=NEW.id_users;
        log_entry = name_voter || ' voted Down on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log)
        VALUES(id_users_profile_vote,log_entry);

        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = NEW.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Down in ur news ' || title_post;
        INSERT INTO notification (id_users_profile,log)
        VALUES(id_users_profile_vote,log_entry);

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
    id_users_profile_vote INTEGER;       /*Id do Commenter*/
BEGIN
    IF NEW.value = 'TRUE' THEN

        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=NEW.id_users;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT comment.id_post INTO id_aux FROM comment WHERE id_comment = NEW.id_comment;
        SELECT post.title INTO title_post FROM post WHERE id_post=id_aux;
        id_users_profile_vote = NEW.id_users;
        log_entry = name_voter || ' voted Up on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log)
        VALUES(id_users_profile_vote,log_entry);

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
        id_users_profile_vote = NEW.id_users;
        log_entry = name_voter || ' voted Down on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        INSERT INTO activity (id_users_profile,log)
        VALUES(id_users_profile_vote,log_entry);

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
    id_users_profile_vote INTEGER;   /*Id do Commenter*/
BEGIN
    IF OLD.value = 'TRUE' THEN

        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=OLD.id_users;
        SELECT post.title INTO title_post FROM post WHERE id_post=OLD.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=OLD.id_users;
        log_entry = name_voter || ' voted Up on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry;
        DELETE FROM activity
        WHERE id_activity = id_aux;

        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = OLD.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Up in ur news ' || title_post;
        SELECT notification.id_notification INTO id_aux FROM notification WHERE id_users_profile = id_users_profile_vote AND log = log_entry;
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
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=OLD.id_users;
        log_entry = name_voter || ' voted Down on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry;
        DELETE FROM activity
        WHERE id_activity = id_aux;

        /*Notificaçao*/
        SELECT post.id_users INTO id_aux FROM post WHERE id_post = OLD.id_post;
        SELECT users_profile.id_users_profile INTO id_users_profile_vote FROM users_profile WHERE id_users=id_aux;
        log_entry = name_voter || 'voted Down in ur news ' || title_post;
        SELECT notification.id_notification INTO id_aux FROM notification WHERE id_users_profile = id_users_profile_vote AND log = log_entry;
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
    id_users_profile_vote INTEGER;       /*Id do Commenter*/
BEGIN
    IF OLD.value = 'TRUE' THEN

        /*Actividade*/
        SELECT users.name INTO name_voter FROM users WHERE id_users=OLD.id_users;
        SELECT comment.id_users INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT users.name INTO name_commenter FROM users WHERE id_users=id_aux;
        SELECT comment.id_post INTO id_aux FROM comment WHERE id_comment = OLD.id_comment;
        SELECT post.title INTO title_post FROM post WHERE id_post=id_aux;
        id_users_profile_vote = OLD.id_users;
        log_entry = name_voter || ' voted Up on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry;
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
        id_users_profile_vote = OLD.id_users;
        log_entry = name_voter || ' voted Down on '|| name_commenter ||'''s comment on "'|| title_post ||'" news';
        SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_profile_vote AND log = log_entry;
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


/*Actividade e notificaçao Follow*/
CREATE FUNCTION delete_activity_notification_follow() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
    name_follower TEXT;              /*Nome do follower*/
    name_followed TEXT;              /*Nome do Followed*/
    log_entry TEXT;                  /*Entrada no logBook*/
    id_users_follower_copy INTEGER;    /*Id do follower*/
BEGIN

    /*Actividade*/
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = OLD.id_users_follower;
    SELECT users.name INTO name_follower FROM users WHERE id_users=id_aux;
    SELECT users_profile.id_users INTO id_aux FROM users_profile WHERE id_users_profile = OLD.id_users_followed;
    SELECT users.name INTO name_followed FROM users WHERE id_users=id_aux;
    log_entry = name_follower || ' followed '|| name_followed;
    id_users_follower_copy = OLD.id_users_follower;
    SELECT activity.id_activity INTO id_aux FROM activity WHERE id_users_profile = id_users_follower_copy AND log = log_entry;
    DELETE FROM activity
    WHERE id_activity = id_aux;

    /*Notificacao*/
    log_entry = name_follower || ' followed you';
    id_users_follower_copy = OLD.id_users_followed;
    SELECT notification.id_notification INTO id_aux FROM notification WHERE id_users_profile = id_users_follower_copy AND log = log_entry;
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

CREATE FUNCTION insert_profile() RETURNS TRIGGER AS
$BODY$
DECLARE
    id_aux INTEGER;
BEGIN
    INSERT INTO users_profile (id_users)
    VALUES(NEW.id_users);
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER insert_profile
AFTER INSERT ON users
FOR EACH ROW
EXECUTE PROCEDURE insert_profile();


/*adicionar algumas insformações essenciais à BD*/
INSERT INTO country (id_country,name) VALUES
(1, 'Afghanistan'),
(2, 'Aland Islands'),
(3, 'Albania'),
(4, 'Algeria'),
(5, 'American Samoa'),
(6, 'Andorra'),
(7, 'Angola'),
(8, 'Anguilla'),
(9, 'Antarctica'),
(10, 'Antigua and Barbuda'),
(11, 'Argentina'),
(12, 'Armenia'),
(13, 'Aruba'),
(14, 'Australia'),
(15, 'Austria'),
(16, 'Azerbaijan'),
(17, 'Bahamas'),
(18, 'Bahrain'),
(19, 'Bangladesh'),
(20, 'Barbados'),
(21, 'Belarus'),
(22, 'Belgium'),
(23, 'Belize'),
(24, 'Benin'),
(25, 'Bermuda'),
(26, 'Bhutan'),
(27, 'Bolivia'),
(28, 'Bonaire, Sint Eustatius and Saba'),
(29, 'Bosnia and Herzegovina'),
(30, 'Botswana'),
(31, 'Bouvet Island'),
(32, 'Brazil'),
(33, 'British Indian Ocean Territory'),
(34, 'Brunei Darussalam'),
(35, 'Bulgaria'),
(36, 'Burkina Faso'),
(37, 'Burundi'),
(38, 'Cambodia'),
(39, 'Cameroon'),
(40, 'Canada'),
(41, 'Cape Verde'),
(42, 'Cayman Islands'),
(43, 'Central African Republic'),
(44, 'Chad'),
(45, 'Chile'),
(46, 'China'),
(47, 'Christmas Island'),
(48, 'Cocos (Keeling) Islands'),
(49, 'Colombia'),
(50, 'Comoros'),
(51, 'Congo'),
(52, 'Democratic Republic of the Congo'),
(53, 'Cook Islands'),
(54, 'Costa Rica'),
(55, 'Cote D\Ivoire'),
(56, 'Croatia'),
(57, 'Cuba'),
(58, 'Curacao'),
(59, 'Cyprus'),
(60, 'Czech Republic'),
(61, 'Denmark'),
(62, 'Djibouti'),
(63, 'Dominica'),
(64, 'Dominican Republic'),
(65, 'Ecuador'),
(66, 'Egypt'),
(67, 'El Salvador'),
(68, 'Equatorial Guinea'),
(69, 'Eritrea'),
(70, 'Estonia'),
(71, 'Ethiopia'),
(72, 'Falkland Islands (Malvinas)'),
(73, 'Faroe Islands'),
(74, 'Fiji'),
(75, 'Finland'),
(76, 'France'),
(77, 'French Guiana'),
(78, 'French Polynesia'),
(79, 'French Southern Territories'),
(80, 'Gabon'),
(81, 'Gambia'),
(82, 'Georgia'),
(83, 'Germany'),
(84, 'Ghana'),
(85, 'Gibraltar'),
(86, 'Greece'),
(87, 'Greenland'),
(88, 'Grenada'),
(89, 'GuadelototalUpe'),
(90, 'Guam'),
(91, 'Guatemala'),
(92, 'Guernsey'),
(93, 'Guinea'),
(94, 'Guinea-Bissau'),
(95, 'Guyana'),
(96, 'Haiti'),
(97, 'Heard Island and Mcdonald Islands'),
(98, 'Holy See (Vatican City State)'),
(99, 'Honduras'),
(100, 'Hong Kong'),
(101, 'Hungary'),
(102, 'Iceland'),
(103, 'India'),
(104, 'Indonesia'),
(105, 'Iran, Islamic Republic of'),
(106, 'Iraq'),
(107, 'Ireland'),
(108, 'Isle of Man'),
(109, 'Israel'),
(110, 'Italy'),
(111, 'Jamaica'),
(112, 'Japan'),
(113, 'Jersey'),
(114, 'Jordan'),
(115, 'Kazakhstan'),
(116, 'Kenya'),
(117, 'Kiribati'),
(118, 'Korea, Democratic People s Republic of'),
(119, 'Korea, Republic of'),
(120, 'Kosovo'),
(121, 'Kuwait'),
(122, 'Kyrgyzstan'),
(123, 'Lao People\s Democratic Republic'),
(124, 'Latvia'),
(125, 'Lebanon'),
(126, 'Lesotho'),
(127, 'Liberia'),
(128, 'Libyan Arab Jamahiriya'),
(129, 'Liechtenstein'),
(130, 'Lithuania'),
(131, 'Luxembourg'),
(132, 'Macao'),
(133, 'Macedonia, the Former Yugoslav Republic of'),
(134, 'Madagascar'),
(135, 'Malawi'),
(136, 'Malaysia'),
(137, 'Maldives'),
(138, 'Mali'),
(139, 'Malta'),
(140, 'Marshall Islands'),
(141, 'Martinique'),
(142, 'Mauritania'),
(143, 'Mauritius'),
(144, 'Mayotte'),
(145, 'Mexico'),
(146, 'Micronesia, Federated States of'),
(147, 'Moldova, Republic of'),
(148, 'Monaco'),
(149, 'Mongolia'),
(150, 'Montenegro'),
(151, 'Montserrat'),
(152, 'Morocco'),
(153, 'Mozambique'),
(154, 'Myanmar'),
(155, 'Namibia'),
(156, 'Nauru'),
(157, 'Nepal'),
(158, 'Netherlands'),
(159, 'Netherlands Antilles'),
(160, 'New Caledonia'),
(161, 'New Zealand'),
(162, 'Nicaragua'),
(163, 'Niger'),
(164, 'Nigeria'),
(165, 'Niue'),
(166, 'Norfolk Island'),
(167, 'Northern Mariana Islands'),
(168, 'Norway'),
(169, 'Oman'),
(170, 'Pakistan'),
(171, 'Palau'),
(172, 'Palestinian Territory, OcctotalUpied'),
(173, 'Panama'),
(174, 'Papua New Guinea'),
(175, 'Paraguay'),
(176, 'Peru'),
(177, 'Philippines'),
(178, 'Pitcairn'),
(179, 'Poland'),
(180, 'Portugal'),
(181, 'Puerto Rico'),
(182, 'Qatar'),
(183, 'Reunion'),
(184, 'Romania'),
(185, 'Russian Federation'),
(186, 'Rwanda'),
(187, 'Saint Barthelemy'),
(188, 'Saint Helena'),
(189, 'Saint Kitts and Nevis'),
(190, 'Saint Lucia'),
(191, 'Saint Martin'),
(192, 'Saint Pierre and Miquelon'),
(193, 'Saint Vincent and the Grenadines'),
(194, 'Samoa'),
(195, 'San Marino'),
(196, 'Sao Tome and Principe'),
(197, 'Saudi Arabia'),
(198, 'Senegal'),
(199, 'Serbia'),
(200, 'Serbia and Montenegro'),
(201, 'Seychelles'),
(202, 'Sierra Leone'),
(203, 'Singapore'),
(204, 'Sint Maarten'),
(205, 'Slovakia'),
(206, 'Slovenia'),
(207, 'Solomon Islands'),
(208, 'Somalia'),
(209, 'South Africa'),
(210, 'South Georgia and the South Sandwich Islands'),
(211, 'South Sudan'),
(212, 'Spain'),
(213, 'Sri Lanka'),
(214, 'Sudan'),
(215, 'Suriname'),
(216, 'Svalbard and Jan Mayen'),
(217, 'Swaziland'),
(218, 'Sweden'),
(219, 'Switzerland'),
(220, 'Syrian Arab Republic'),
(221, 'Taiwan, Province of China'),
(222, 'Tajikistan'),
(223, 'Tanzania, United Republic of'),
(224, 'Thailand'),
(225, 'Timor-Leste'),
(226, 'Togo'),
(227, 'Tokelau'),
(228, 'Tonga'),
(229, 'Trinidad and Tobago'),
(230, 'Tunisia'),
(231, 'Turkey'),
(232, 'Turkmenistan'),
(233, 'Turks and Caicos Islands'),
(234, 'Tuvalu'),
(235, 'Uganda'),
(236, 'Ukraine'),
(237, 'United Arab Emirates'),
(238, 'United Kingdom'),
(239, 'United States'),
(240, 'United States Minor Outlying Islands'),
(241, 'Uruguay'),
(242, 'Uzbekistan'),
(243, 'Vanuatu'),
(244, 'Venezuela'),
(245, 'Viet Nam'),
(246, 'Virgin Islands, British'),
(247, 'Virgin Islands, U.s.'),
(248, 'Wallis and Futuna'),
(249, 'Western Sahara'),
(250, 'Yemen'),
(251, 'Zambia'),
(252, 'Zimbabwe');


insert into lbaw2194.category (name) values ('Science and Tech');
insert into lbaw2194.category (name) values ('Sports');
insert into lbaw2194.category (name) values ('Music');
insert into lbaw2194.category (name) values ('Fitness and Life Style');
insert into lbaw2194.category (name) values ('World');
insert into lbaw2194.category (name) values ('Portugal');
insert into lbaw2194.category (name) values ('Food and Recipe');
insert into lbaw2194.category (name) values ('Fashion');
insert into lbaw2194.category (name) values ('Cinema');
insert into lbaw2194.category (name) values ('Gamming');
insert into lbaw2194.category (name) values ('Business');
insert into lbaw2194.category (name) values ('COVID-19');
insert into lbaw2194.category (name) values ('Home Decor');
insert into lbaw2194.category (name) values ('Social');
insert into lbaw2194.category (name) values ('Gossip');
