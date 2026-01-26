CREATE TABLE USERS (
    info_public_key CHAR(33) NOT NULL,
    info_permissions CHAR(1) NOT NULL,
    info_name VARCHAR2(25) NOT NULL,
    parent_sign_info CHAR(64),
    parent_info_public_key CHAR(33)
);
ALTER TABLE USERS ADD CONSTRAINT users_pk PRIMARY KEY (info_public_key);
ALTER TABLE USERS ADD CONSTRAINT users_fk1 FOREIGN KEY (parent_info_public_key) REFERENCES USERS(info_public_key);

--================================================================

CREATE TABLE ATTACHMENTS (
    file_hash CHAR(32) NOT NULL,
    file_address VARCHAR2(250) NOT NULL,
    sign_file CHAR(64) NOT NULL,
    user_info_public_key CHAR(33) NOT NULL
);
ALTER TABLE ATTACHMENTS ADD CONSTRAINT attachments_pk PRIMARY KEY (
    file_hash,
    file_address,
    user_info_public_key
);
ALTER TABLE ATTACHMENTS ADD CONSTRAINT attachments_fk1 FOREIGN KEY (user_info_public_key) REFERENCES USERS(info_public_key);

--================================================================

CREATE TABLE POLLS (
    info_name VARCHAR2(100) NOT NULL,
    info_poll_start TIMESTAMP(1) WITH LOCAL TIME ZONE,
    info_poll_end TIMESTAMP(1) WITH TIME ZONE,
    sign_poll CHAR(64),
    user_info_public_key CHAR(33) NOT NULL
);
ALTER TABLE POLLS ADD CONSTRAINT polls_pk PRIMARY KEY (user_info_public_key, info_name);
ALTER TABLE POLLS ADD CONSTRAINT polls_fk1 FOREIGN KEY (user_info_public_key) REFERENCES USERS(info_public_key);

--================================================================

CREATE TABLE CT_ATTACHMENTS_X_POLLS (
    --x
    attachment_file_hash CHAR(32) NOT NULL,
    attachment_file_address VARCHAR2(250) NOT NULL,
    attachment_info_public_key CHAR(33) NOT NULL,
    --y
    poll_info_public_key CHAR(33) NOT NULL,
    poll_info_name VARCHAR2(100) NOT NULL
);

ALTER TABLE CT_ATTACHMENTS_X_POLLS ADD CONSTRAINT ct_attachments_x_polls_pk PRIMARY KEY (
    --x
    attachment_file_hash,
    attachment_file_address,
    attachment_info_public_key,
    --y
    poll_info_public_key,
    poll_info_name
);

--x
ALTER TABLE CT_ATTACHMENTS_X_POLLS ADD CONSTRAINT ct_attachments_x_polls_fk1 FOREIGN KEY (
    attachment_file_hash,
    attachment_file_address,
    attachment_info_public_key
) REFERENCES ATTACHMENTS(
    file_hash,
    file_address,
    user_info_public_key
);

--y
ALTER TABLE CT_ATTACHMENTS_X_POLLS ADD CONSTRAINT ct_attachments_x_polls_fk2 FOREIGN KEY (
    poll_info_public_key,
    poll_info_name
) REFERENCES POLLS(
    user_info_public_key,
    info_name
);

--================================================================

CREATE TABLE OPTIONS (
    name VARCHAR2(50) NOT NULL,
    min_value CHAR(32),
    max_value CHAR(32),
    poll_user_info_public_key CHAR(33) NOT NULL,
    poll_info_name VARCHAR2(100) NOT NULL
);

ALTER TABLE OPTIONS ADD CONSTRAINT options_pk PRIMARY KEY (
    name,
    poll_user_info_public_key,
    poll_info_name
);

ALTER TABLE OPTIONS ADD CONSTRAINT options_fk1 FOREIGN KEY (
    poll_user_info_public_key,
    poll_info_name
) REFERENCES POLLS(
    user_info_public_key,
    info_name
);

--================================================================

CREATE TABLE MEMBERS (
    --entry as a commit `H(s || k)`
    commit_array_index INTEGER,
    commit_hash CHAR(32),
    commit_previous_entry CHAR(32),
    commit_poll CHAR(32),
    sign_commit CHAR(64),
    --x
    user_info_public_key CHAR(33) NOT NULL,
    --y
    poll_user_info_public_key CHAR(33) NOT NULL,
    poll_info_name VARCHAR2(100) NOT NULL
);

--x
ALTER TABLE MEMBERS ADD CONSTRAINT members_fk1 FOREIGN KEY (user_info_public_key) REFERENCES USERS(info_public_key);

--y
ALTER TABLE MEMBERS ADD CONSTRAINT members_fk2 FOREIGN KEY (
    poll_user_info_public_key,
    poll_info_name
) REFERENCES POLLS(
    user_info_public_key,
    info_name
);

ALTER TABLE MEMBERS ADD CONSTRAINT members_pk PRIMARY KEY (
    --x
    user_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
);

--================================================================

CREATE TABLE VOTES (
    --zk-proof with binded informations:
    vote_value CHAR(32) NOT NULL,
    vote_entries_root CHAR(32) NOT NULL,
    vote_nullifier CHAR(32) NOT NULL,
    vote_previous_vote CHAR(32),
    proof_vote CLOB NOT NULL,       --may depend on used zk-proving system (format of the proof) (expecting JSON)
    --x
    option_name VARCHAR2(50),
    option_info_public_key RAW(33),
    option_info_name VARCHAR2(100)
);

ALTER TABLE VOTES ADD CONSTRAINT vote_option_fk FOREIGN KEY (
    option_name,
    option_info_public_key,
    option_info_name
) REFERENCES OPTIONS(
    name,
    poll_user_info_public_key,
    poll_info_name
);