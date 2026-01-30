--================================================================

-- Wykorzystywane protokoły kryptograficzne:
-- -- System podpisów: ECDSA (curve: secp256k1)
-- -- Funkcja skrótu: SHA256
-- -- System dowodów zerowej wiedzy (jako dowód obliczeniowy): zkSNARK (protocol: groth16)
-- -- -- Funkcja skrótu: Poseidon Hash

--================================================================

CREATE TABLE USERS (
    info_public_key RAW(33) NOT NULL,       --ECDSA public key
    info_permissions RAW(1) NOT NULL,
    info_name VARCHAR2(25) NOT NULL,
    parent_sign_info RAW(64),               --ECDSA signature
    parent_info_public_key RAW(33)          --ECDSA public key
);
ALTER TABLE USERS ADD CONSTRAINT users_pk PRIMARY KEY (info_public_key);
ALTER TABLE USERS ADD CONSTRAINT users_fk1 FOREIGN KEY (parent_info_public_key) REFERENCES USERS(info_public_key);

--================================================================

CREATE TABLE ATTACHMENTS (
    file_hash RAW(32) NOT NULL,             --SHA256
    file_address VARCHAR2(250) NOT NULL,
    sign_file RAW(64) NOT NULL,             --ECDSA signature
    user_info_public_key RAW(33) NOT NULL   --ECDSA public key
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
    sign_poll RAW(64),                                  --ECDSA signature
    user_info_public_key RAW(33) NOT NULL               --ECDSA public key
);
ALTER TABLE POLLS ADD CONSTRAINT polls_pk PRIMARY KEY (user_info_public_key, info_name);
ALTER TABLE POLLS ADD CONSTRAINT polls_fk1 FOREIGN KEY (user_info_public_key) REFERENCES USERS(info_public_key);

--================================================================

CREATE TABLE CT_ATTACHMENTS_X_POLLS (
    --x
    attachment_file_hash RAW(32) NOT NULL,
    attachment_file_address VARCHAR2(250) NOT NULL,
    attachment_info_public_key RAW(33) NOT NULL,
    --y
    poll_user_info_public_key RAW(33) NOT NULL,         --ECDSA public key
    poll_info_name VARCHAR2(100) NOT NULL
);

ALTER TABLE CT_ATTACHMENTS_X_POLLS ADD CONSTRAINT ct_attachments_x_polls_pk PRIMARY KEY (
    --x
    attachment_file_hash,
    attachment_file_address,
    attachment_info_public_key,
    --y
    poll_user_info_public_key,
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
    poll_user_info_public_key,
    poll_info_name
) REFERENCES POLLS(
    user_info_public_key,
    info_name
);

--================================================================

CREATE TABLE OPTIONS (
    name VARCHAR2(75) NOT NULL,
    min_value NUMBER(38,0) CHECK (min_value >= 0),
    max_value NUMBER(38,0) CHECK (max_value >= 0),
    poll_user_info_public_key RAW(33) NOT NULL,
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
    commit_hash RAW(32),                        --zkSNARK signal
    commit_previous_entry RAW(32),              --SHA256
    commit_poll RAW(32),
    sign_commit RAW(64),                        --ECDSA signature
    --x
    user_info_public_key RAW(33) NOT NULL,      --ECDSA public key
    --y
    poll_user_info_public_key RAW(33) NOT NULL, --ECDSA public key
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
    vote_value RAW(32) NOT NULL,                    --zkSNARK public signal
    vote_entries_root RAW(32) NOT NULL,             --zkSNARK public signal, Poseidon Hash
    vote_nullifier RAW(32) NOT NULL,                --zkSNARK public signal
    vote_previous_vote RAW(32),                     --zkSNARK public signal, Poseidon Hash
    proof_vote CLOB NOT NULL,                       --zkSNARK proof
    --x
    poll_user_info_public_key RAW(33) NOT NULL,
    poll_info_name VARCHAR2(100) NOT NULL,
    --y (optional relation) 
    option_name VARCHAR2(50),
    option_info_public_key RAW(33),
    option_info_name VARCHAR2(100)
);

ALTER TABLE VOTES ADD CONSTRAINT votes_pk PRIMARY KEY (vote_nullifier, poll_user_info_public_key, poll_info_name);

--x
ALTER TABLE VOTES ADD CONSTRAINT votes_fk2 FOREIGN KEY (
    poll_user_info_public_key,
    poll_info_name
) REFERENCES POLLS(
    user_info_public_key,
    info_name
);

--y (optional relation)
ALTER TABLE VOTES ADD CONSTRAINT votes_fk1 FOREIGN KEY (
    option_name,
    option_info_public_key,
    option_info_name
) REFERENCES OPTIONS(
    name,
    poll_user_info_public_key,
    poll_info_name
);
