CREATE TABLE user (
    id              MEDIUMINT   NOT NULL,
    external_id     INT         NOT NULL,
    author_id       MEDIUMINT   NOT NULL,
    count           SMALLINT    DEFAULT 0,
    PRIMARY KEY(id)
);
