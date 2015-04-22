CREATE TABLE edsa_user (
  usf_uid       varchar(20) NOT NULL,
  fname         varchar(20) NOT NULL,
  minit         char(1),
  lname         varchar(20) NOT NULL,
  email         varchar(100),

  PRIMARY KEY (usf_uid)
);

CREATE TABLE project (
  proj_id       integer NOT NULL,
  proj_title    varchar(40) NOT NULL,
  creator       varchar(20) NOT NULL,
  created_at    timestamp NOT NULL DEFAULT now(),
  notes         text,

  PRIMARY KEY (proj_id),
  FOREIGN KEY (creator) REFERENCES edsa_user(usf_uid),
  CONSTRAINT creator_proj_unq UNIQUE (creator, proj_title)
);

CREATE TABLE experiment (
  proj_id       integer NOT NULL,
  exp_id        integer NOT NULL,
  exp_title     varchar(20) NOT NULL,
  notes         text,

  PRIMARY KEY (exp_id),
  FOREIGN KEY (proj_id) REFERENCES project(proj_id),
  CONSTRAINT proj_exp_title_uniq UNIQUE (proj_id, exp_title)
);

CREATE TABLE file_type (
  ft_id         integer NOT NULL,
  ft_name       varchar(20) NOT NULL,
  ext           varchar(10) NOT NULL,
  supported     boolean NOT NULL,

  PRIMARY KEY (ft_id)
);

CREATE TABLE data_type (
  dt_id         integer NOT NULL,
  dt_name       varchar(20) NOT NULL, --such as waveform or xy

  PRIMARY KEY (dt_id)
);
CREATE TYPE storage_type AS ENUM ('flat','table');

CREATE TABLE data_set (
  exp_id        integer NOT NULL,
  ds_id         integer NOT NULL,
  ds_title      varchar(20) NOT NULL,
  d_type        integer,
  storage_type  storage_type,
  location      varchar(200),
  xunit         varchar(200),
  yunit         varchar(200), 
  dt            double precision, -- this is the time unit in waveforms
  notes         text,

  PRIMARY KEY (ds_id),
  FOREIGN KEY (exp_id) REFERENCES experiment(exp_id),
  FOREIGN KEY (d_type) REFERENCES data_type(dt_id),
  CONSTRAINT proj_ds_unique UNIQUE (exp_id, ds_title)
  -- need some sort of constraint to verify that if its a flat file,
  -- location is an address and if its a table then location is the table
  -- name
);
-- add a constraint/trigger of some kind to make sure that the ds 
-- titles are unique within each project, so the combination of 
-- proj_title and ds_title will be unique for the entire db

CREATE TABLE flat_file (
  ff_id         integer NOT NULL, 
  ds_id         integer NOT NULL,
  f_type        integer,
  header        boolean,
  field_separator char(2),
  notes         text,

  PRIMARY KEY (ff_id),
  FOREIGN KEY (ds_id) REFERENCES data_set(ds_id),
  FOREIGN KEY (f_type) REFERENCES file_type(ft_id)
);

CREATE TYPE permissions_group AS ENUM ('owner','group');

CREATE TABLE permission_type (
  code          integer NOT NULL,
  name          varchar(18) NOT NULL,
  
  PRIMARY KEY (code)
);

INSERT INTO permission_type VALUES
(0,   'restricted'),
(4,   'read'),
(6,   'read/write'),
(7,   'read/write/execute');

CREATE TABLE permissions (
  proj_id       integer NOT NULL,
  usf_uid       varchar(20) NOT NULL,
  p_group       permissions_group NOT NULL,
  p_type        integer NOT NULL,

  PRIMARY KEY (proj_id, usf_uid),
  FOREIGN KEY (proj_id) REFERENCES project(proj_id),
  FOREIGN KEY (usf_uid) REFERENCES edsa_user(usf_uid),
  FOREIGN KEY (p_type) REFERENCES permission_type(code)
);

CREATE TABLE condition (
  cond_id     integer NOT NULL,
  exp_id      integer NOT NULL,
  cond_title  varchar(20) NOT NULL,
  unit        varchar(20) NULL,
  value       varchar(20) NOT NULL,

  PRIMARY KEY (cond_id),
  CONSTRAINT exp_cond_title_unique UNIQUE (exp_id, cond_title),
  FOREIGN KEY (exp_id) REFERENCES experiment(exp_id)
);
