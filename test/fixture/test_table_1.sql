CREATE TABLE article (
    id              INT                 NOT NULL,
    external_id     INT UNSIGNED        NOT NULL,
    author_id       MEDIUMINT           NOT NULL,
    count           SMALLINT            DEFAULT 0,
    title           VARCHAR(255)        NOT NULL,
    content         TEXT                NOT NULL,
    PRIMARY KEY(id)
);
