CREATE TABLE language(
lid INT check (lid>0),
lname VARCHAR(20) NOT NULL,
PRIMARY KEY (lid)
);


CREATE TABLE "user"(
uid INT UNIQUE check (uid>0),
uname VARCHAR(50) NOT NULL,
country VARCHAR(50) NOT NULL,
joindate DATE NOT NULL,
DOB DATE NOT NULL,
gender CHAR NOT NULL check (gender='M' or gender='F'),
email VARCHAR(50) NOT NULL check (email like '%@%'),
PRIMARY KEY (uid)
);


CREATE TABLE Channel(
cid INT,
uid INT NOT NULL,
cname VARCHAR(50) NOT NULL,
createdate DATE NOT NULL,
PRIMARY KEY (cid),
FOREIGN KEY (uid) REFERENCES "user"(uid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE subtitle(
sid INT,
filename VARCHAR(50) NOT NULL,
lid INT NOT NULL,
PRIMARY KEY (sid),
FOREIGN KEY (lid) REFERENCES language(lid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE video(
vid INT UNIQUE check (vid>0),
vname VARCHAR(100),
timestamp DATE NOT NULL,
duration INT NOT NULL check (duration>0),
cid INT NOT NULL,
lid INT NOT NULL,
sid INT,
PRIMARY KEY (vid),
FOREIGN KEY (lid) REFERENCES language(lid) ON DELETE SET DEFAULT ON UPDATE 
CASCADE,
FOREIGN KEY (cid) REFERENCES channel(cid) ON DELETE SET DEFAULT ON UPDATE 
CASCADE,
FOREIGN KEY (sid) REFERENCES subtitle(sid) ON DELETE SET DEFAULT ON UPDATE 
CASCADE
);


CREATE TABLE tagvideo(
vid INT,
tag VARCHAR(50),
PRIMARY KEY (vid,tag),
FOREIGN KEY (vid) REFERENCES video(vid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE subscribed_by(
uid INT,
cid INT,
PRIMARY KEY (uid,cid),
FOREIGN KEY (uid) REFERENCES "user"(uid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (cid) REFERENCES channel(cid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE likedislike(
uid INT,
vid INT,
likedislike BOOL,
PRIMARY KEY (uid,vid),
FOREIGN KEY (uid) REFERENCES "user"(uid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (vid) REFERENCES video(vid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE comment_by(
uid INT,
vid INT,
content VARCHAR(1000) NOT NULL,
timestamp DATE NOT NULL,
PRIMARY KEY (uid,vid,timestamp),
FOREIGN KEY (uid) REFERENCES "user"(uid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (vid) REFERENCES video(vid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE playlist(
pid INT,
uid INT NOT NULL,
PRIMARY KEY (pid),
FOREIGN KEY (uid) REFERENCES "user"(uid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE has(
pid INT,
vid INT,
PRIMARY KEY (pid,vid),
FOREIGN KEY (pid) REFERENCES playlist(pid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (vid) REFERENCES video(vid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE seen_by(
vid INT,
uid INT,
timestamp DATE,
PRIMARY KEY (vid,uid,timestamp),
FOREIGN KEY (vid) REFERENCES video(vid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (uid) REFERENCES "user"(uid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE advertisement(
advid INT,
advname VARCHAR(50),
costperview REAL,
PRIMARY KEY (advid)
);


CREATE TABLE pop(
advid INT NOT NULL,
vid INT NOT NULL,
uid INT NOT NULL,
timestamp DATE NOT NULL,
PRIMARY KEY (advid,vid,uid,timestamp),
FOREIGN KEY (vid,uid,timestamp) REFERENCES seen_by(vid,uid,timestamp) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (advid) REFERENCES advertisement(advid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);