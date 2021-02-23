CREATE TABLE domains (
  id                    INT AUTO_INCREMENT,
  NAME                  VARCHAR(255) NOT NULL,
  MASTER                VARCHAR(128) DEFAULT NULL,
  last_check            INT DEFAULT NULL,
  TYPE                  VARCHAR(6) NOT NULL,
  notified_serial       INT DEFAULT NULL,
  account               VARCHAR(40) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=INNODB;
CREATE UNIQUE INDEX name_index ON domains(NAME);
CREATE TABLE records (
  id                    BIGINT AUTO_INCREMENT,
  domain_id             INT DEFAULT NULL,
  NAME                  VARCHAR(255) DEFAULT NULL,
  TYPE                  VARCHAR(10) DEFAULT NULL,
  content               TEXT DEFAULT NULL,
  ttl                   INT DEFAULT NULL,
  prio                  INT DEFAULT NULL,
  change_date           INT DEFAULT NULL,
  disabled              TINYINT(1) DEFAULT 0,
  ordername             VARCHAR(255) BINARY DEFAULT NULL,
  auth                  TINYINT(1) DEFAULT 1,
  PRIMARY KEY (id)
) ENGINE=INNODB;
CREATE INDEX nametype_index ON records(NAME,TYPE);
CREATE INDEX domain_id ON records(domain_id);
CREATE INDEX recordorder ON records (domain_id, ordername);
CREATE TABLE supermasters (
  ip                    VARCHAR(64) NOT NULL,
  nameserver            VARCHAR(255) NOT NULL,
  account               VARCHAR(40) NOT NULL,
  PRIMARY KEY (ip, nameserver)
) ENGINE=INNODB;
CREATE TABLE comments (
  id                    INT AUTO_INCREMENT,
  domain_id             INT NOT NULL,
  NAME                  VARCHAR(255) NOT NULL,
  TYPE                  VARCHAR(10) NOT NULL,
  modified_at           INT NOT NULL,
  account               VARCHAR(40) NOT NULL,
  COMMENT               TEXT NOT NULL,
  PRIMARY KEY (id)
) ENGINE=INNODB;
CREATE INDEX comments_domain_id_idx ON comments (domain_id);
CREATE INDEX comments_name_type_idx ON comments (NAME, TYPE);
CREATE INDEX comments_order_idx ON comments (domain_id, modified_at);
CREATE TABLE domainmetadata (
  id                    INT AUTO_INCREMENT,
  domain_id             INT NOT NULL,
  kind                  VARCHAR(32),
  content               TEXT,
  PRIMARY KEY (id)
) ENGINE=INNODB;
CREATE INDEX domainmetadata_idx ON domainmetadata (domain_id, kind);
CREATE TABLE cryptokeys (
  id                    INT AUTO_INCREMENT,
  domain_id             INT NOT NULL,
  flags                 INT NOT NULL,
  active                BOOL,
  content               TEXT,
  PRIMARY KEY(id)
) ENGINE=INNODB;
CREATE INDEX domainidindex ON cryptokeys(domain_id);
CREATE TABLE tsigkeys (
  id                    INT AUTO_INCREMENT,
  NAME                  VARCHAR(255),
  ALGORITHM             VARCHAR(50),
  secret                VARCHAR(255),
  PRIMARY KEY (id)
) ENGINE=INNODB;
CREATE UNIQUE INDEX namealgoindex ON tsigkeys(NAME, ALGORITHM);