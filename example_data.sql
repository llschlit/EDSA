INSERT INTO edsa_user VALUES
('jbrown',  'Joe',      'P',    'Brown'),
('felixf',  'Felix',    null,   'Felicius'),
('asmith',  'Andrea',   'L',    'Smith'),
('sgummy',  'Susan',    'C',    'Gummy');

INSERT INTO project VALUES
(100,   'project1',       'jbrown'),
(101,   'project2',       'jbrown'),
(102,   'project3',       'jbrown'),
(103,   'Animal Project', 'sgummy'),
(104,   'Weather',        'sgummy'),
(105,   'Temperature',    'sgummy'),
(106,   'p1',             'felixf'),
(107,   'p2',             'felixf'),
(108,   'p3',             'felixf'),
(109,   '2012',           'asmith'),
(110,   '2013',           'asmith'),
(111,   '2014',           'asmith');

INSERT INTO file_type VALUES
(1,   'CSV',          '.csv',   TRUE),
(2,   'Data',         '.dat',   TRUE),
(3,   'Fixed Width',  '.fwf',   TRUE);

INSERT INTO data_type VALUES
(1,   'xy'),
(2,   'waveform'),
(3,   'xyz');

INSERT INTO experiment VALUES
(100, 10000, 'exp1',   1,  'table',  'good set'),
(100, 10001, 'exp2',   1,  'table',  'foo'),
(100, 10002, 'exp3',   1,  'table',  'bar'),
(101, 10003, 'exp1',   1,  'table',  NULL),
(101, 10004, 'exp2',   1,  'table',  NULL),
(101, 10005, 'exp3',   1,  'table',  NULL),
(102, 10006, 'exp1',   2,  'flat',   'waveform'),
(102, 10007, 'exp2',   2,  'flat',   'waveform'),
(102, 10008, 'exp3',   2,  'flat',   'waveform');

INSERT INTO flat_file VALUES
(1, 10006,  '~/project3/waveform1.csv',  1, TRUE, ','),
(2, 10007,  '~/project3/waveform2.csv',  1, TRUE, ','),
(3, 10008,  '~/project3/waveform3.csv',  1, TRUE, ',');

INSERT INTO permissions VALUES
(100,   'jbrown',   'owner',  7),
(101,   'jbrown',   'owner',  7),
(101,   'sgummy',   'group',  4),
(102,   'jbrown',   'owner',  7),
(103,   'sgummy',   'owner',  7),
(103,   'jbrown',   'group',  4),
(103,   'felixf',   'group',  4),
(104,   'sgummy',   'owner',  7),
(105,   'sgummy',   'owner',  7),
(106,   'felixf',   'owner',  7),
(106,   'asmith',   'group',  6),
(107,   'felixf',   'owner',  7),
(108,   'felixf',   'owner',  7),
(108,   'jbrown',   'group',  6),
(109,   'asmith',   'owner',  7),
(110,   'asmith',   'owner',  7),
(110,   'sgummy',   'group',  4),
(111,   'asmith',   'owner',  7);

INSERT INTO data_table VALUES 
(102, 10006, 'jbrown10210006'),
(102, 10007, 'jbrown10210007'),
(102, 10008, 'jbrown10210008');
