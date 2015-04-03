CREATE TABLE edsa_user (
  usf_uid       char(20) NOT NULL,
  fname         char(20) NOT NULL,
  minit         char(1),
  lname         char(20) NOT NULL,
  email         char(100),

  PRIMARY KEY (usf_uid)
);

CREATE TABLE project (
  proj_id       integer NOT NULL,
  proj_title    char(20) NOT NULL,
  creator       char(20) NOT NULL,
  created_at    timestamp NOT NULL DEFAULT now(),
  notes         text,

  PRIMARY KEY (proj_id),
  FOREIGN KEY (creator) REFERENCES edsa_user(usf_uid)
);

CREATE TABLE file_type (
  ft_id         integer NOT NULL,
  ft_name       char(20) NOT NULL,
  ext           char(10) NOT NULL,
  supported     boolean NOT NULL,

  PRIMARY KEY (ft_id)
);

CREATE TABLE data_type (
  dt_id         integer NOT NULL,
  dt_name       char(20) NOT NULL, --such as waveform or xy

  PRIMARY KEY (dt_id)
);
CREATE TYPE storage_type AS ENUM ('flat','table');

CREATE TABLE experiment (
  exp_id        integer NOT NULL,
  proj_id       integer NOT NULL,
  exp_title     char(20) NOT NULL,
  d_type        integer,
  storage_type  storage_type,
  notes         text,

  PRIMARY KEY (exp_id),
  FOREIGN KEY (proj_id) REFERENCES project(proj_id),
  FOREIGN KEY (d_type) REFERENCES data_type(dt_id)
);

CREATE TABLE flat_file (
  ff_id         integer NOT NULL, 
  exp_id        integer NOT NULL,
  f_location    char(200),
  f_type        integer,
  header        boolean,
  field_separator char(2),
  notes         text,

  PRIMARY KEY (ff_id),
  FOREIGN KEY (exp_id) REFERENCES experiment(exp_id),
  FOREIGN KEY (f_type) REFERENCES file_type(ft_id)
);

CREATE TYPE permissions_group AS ENUM ('owner','group');

CREATE TABLE permission_type (
  code          integer NOT NULL,
  name          char(18) NOT NULL,
  
  PRIMARY KEY (code)
);

INSERT INTO permission_type VALUES
(0,   'restricted'),
(4,   'read'),
(6,   'read/write'),
(7,   'read/write/execute');

CREATE TABLE permissions (
  proj_id       integer NOT NULL,
  usf_uid       char(20) NOT NULL,
  p_group       permissions_group NOT NULL,
  p_type        integer NOT NULL,

  PRIMARY KEY (proj_id, usf_uid),
  FOREIGN KEY (proj_id) REFERENCES project(proj_id),
  FOREIGN KEY (usf_uid) REFERENCES edsa_user(usf_uid),
  FOREIGN KEY (p_type) REFERENCES permission_type(code)
);
