--================================================================

-- System rejestruje Admina

INSERT INTO USERS (
    info_public_key,
    info_permissions,
    info_name,
    parent_sign_info,
    parent_info_public_key
) VALUES (
    HEXTORAW('02eac3f42f6192b898652c8eea24fc00e0d9ddfbf3b73b55dda4fd44cb374f82f3'),
    HEXTORAW('FF'),
    'Admin',
    --sign, author
    NULL,
    NULL
);

--================================================================

-- System (po weyfikacji podpisu) pozwala Adminowy: zarejestrować Alicje

INSERT INTO USERS (
    info_public_key,
    info_permissions,
    info_name,
    parent_sign_info,
    parent_info_public_key
) VALUES (
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    HEXTORAW('3F'),
    'Alicja',
    --sign, author
    HEXTORAW('699e452fb2b8df51c57aaed57c5e640944a06e273f9c5ec89ef85735dcfff1bf3829d508d2a38a2d5976591aa2419fec5ce254641c29733213b2242dea785d2f'),
    HEXTORAW('02eac3f42f6192b898652c8eea24fc00e0d9ddfbf3b73b55dda4fd44cb374f82f3')
);

-- System (po weyfikacji podpisu) pozwala Adminowy: zarejestrować Adama

INSERT INTO USERS (
    info_public_key,
    info_permissions,
    info_name,
    parent_sign_info,
    parent_info_public_key
) VALUES (
    HEXTORAW('020340726a7434cb3cf0e4a32b546497079330145525d52c0fee38d48df384a282'),
    HEXTORAW('3F'),
    'Adam',
    --sign, author
    HEXTORAW('8b4c66467a4ea4565e5fe0fdeeed6c1970fd3ea232025957aa111a9ed061583b5dc1bde2df0c2139db6fff5ea695d7dbfa8c66d96412bb25ea63b510f3eb123a'),
    HEXTORAW('02eac3f42f6192b898652c8eea24fc00e0d9ddfbf3b73b55dda4fd44cb374f82f3')
);

-- System (po weyfikacji podpisu) pozwala Adminowy: zarejestrować Ewe

INSERT INTO USERS (
    info_public_key,
    info_permissions,
    info_name,
    parent_sign_info,
    parent_info_public_key
) VALUES (
    HEXTORAW('024e747154f1843e8e24b750e6ac3f96b9206ed98a7fa13585321031f1d8019fdb'),
    HEXTORAW('3F'),
    'Ewa',
    --sign, author
    HEXTORAW('7e13c9ecc38ea22b6998d9fc569800a80f8e642df1101c7434801f53d1b884ea03018e08070542248f978fb99c995685cbe08d8dcd3182fdd387421d65de79a3'),
    HEXTORAW('02eac3f42f6192b898652c8eea24fc00e0d9ddfbf3b73b55dda4fd44cb374f82f3')
);


-- System (po weyfikacji podpisu) pozwala Adminowy: zarejestrować Wiktora

INSERT INTO USERS (
    info_public_key,
    info_permissions,
    info_name,
    parent_sign_info,
    parent_info_public_key
) VALUES (
    HEXTORAW('03b7e0e0383a0908ab0c33fb6b00519ad78312c8f2a15e8d6ea8671f500e47eddd'),
    HEXTORAW('3F'),
    'Wiktor',
    --sign, author
    HEXTORAW('aa56c708c20b3ebb45aa7e0373039e8cf342ac6c195a6c12d08095542991ea764b16ec6c0ace7a204f50bcc9d882f93e550f578378dde5f03e9b202e26d0bc01'),
    HEXTORAW('02eac3f42f6192b898652c8eea24fc00e0d9ddfbf3b73b55dda4fd44cb374f82f3')
);

-- System (po weyfikacji podpisu) pozwala Adminowy: zarejestrować Peggy

INSERT INTO USERS (
    info_public_key,
    info_permissions,
    info_name,
    parent_sign_info,
    parent_info_public_key
) VALUES (
    HEXTORAW('021435d498cbe86ad67a8b62b768197543e88f3330c054f358ad153ec5fb898b70'),
    HEXTORAW('3F'),
    'Peggy',
    --sign, author
    HEXTORAW('d8878938db754a611ebf8fadc8b8845168596a3128abede52ad25ae01a5c576b5096c7b1a20575b4911424513551ebafb86d9b96af42c151b46f25d258cf84cd'),
    HEXTORAW('02eac3f42f6192b898652c8eea24fc00e0d9ddfbf3b73b55dda4fd44cb374f82f3')
);

--================================================================

-- System pozwala Alicji: stworzyć nie-aktywne głosowanie

INSERT INTO POLLS (
    info_name,
    info_poll_start,
    info_poll_end,
    --sign, author
    sign_poll,
    user_info_public_key
) VALUES (
    'my-first-anon-poll',
    NULL,
    NULL,
    --sign, author
    NULL,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
);

--================================================================

-- System (po weyfikacji podpisu) pozwala Alicji: zarejestrować załącznik do pliku `majster.jpg`

INSERT INTO ATTACHMENTS (
    file_hash,
    file_address,
    --sign, author
    sign_file,
    user_info_public_key
) VALUES (
    HEXTORAW('7aadde35111e11442c89ee7ea02e191c5bcca18218ef6955feedb54b45be4f23'),
    'https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/majster.jpg',
    --sign, author
    HEXTORAW('5fcac83e327bd2a7238cc4938a501b53aee5bd460b38524307af11b205dd891375bb1bb8ba774953b420ec7f6f4481fd11d69330123ce5299e38c2191ec0a725'),
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
);

-- System (po weyfikacji podpisu) pozwala Alicji: zarejestrować załącznik do pliku `readme.md`

INSERT INTO ATTACHMENTS (
    file_hash,
    file_address,
    --sign, author
    sign_file,
    user_info_public_key
) VALUES (
    HEXTORAW('2b8244fd9086fc945a340b85f28ab7f759351715f07479ee887c2fea98f8870e'),
    'https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/readme.md',
    --sign, author
    HEXTORAW('3dc5a63a1af09d3a1e3d3caaf6725b9bea1d3970aab745e0abebb1d08438599d5cc26b027717cf7d8a3ad7b43ac1e660110bff374ce93c7ec9fab796016293d2'),
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
);

--================================================================

-- System pozwala Alicji: przypisać jej załącznik `majster.jpg` do jej głosowania 'my-first-anon-poll'

INSERT INTO CT_ATTACHMENTS_X_POLLS (
    --x
    attachment_file_hash,
    attachment_file_address,
    attachment_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    --x
    HEXTORAW('7aadde35111e11442c89ee7ea02e191c5bcca18218ef6955feedb54b45be4f23'),
    'https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/majster.jpg',
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    --y
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: przypisać jej załącznik `readme.md` do jej głosowania 'my-first-anon-poll'

INSERT INTO CT_ATTACHMENTS_X_POLLS (
    --x
    attachment_file_hash,
    attachment_file_address,
    attachment_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    --x
    HEXTORAW('2b8244fd9086fc945a340b85f28ab7f759351715f07479ee887c2fea98f8870e'),
    'https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/readme.md',
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    --y
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

--================================================================

-- System pozwala Alicji: dodać opcje 'Jabłkowy' do jej głosowania 'my-first-anon-poll'

INSERT INTO OPTIONS (
    name,
    min_value,
    max_value,
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    'Jabłkowy',
    0,
    0,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: dodać opcje 'Pomarańczowy' do jej głosowania 'my-first-anon-poll'

INSERT INTO OPTIONS (
    name,
    min_value,
    max_value,
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    'Pomarańczowy',
    1,
    1,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: dodać opcje 'Marchewkowy' do jej głosowania 'my-first-anon-poll'

INSERT INTO OPTIONS (
    name,
    min_value,
    max_value,
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    'Marchewkowy',
    2,
    2,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: dodać opcje 'nie wiem, ale napewno dobry.' do jej głosowania 'my-first-anon-poll'

INSERT INTO OPTIONS (
    name,
    min_value,
    max_value,
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    'nie wiem, ale napewno dobry.',
    3,
    3,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: dodać opcje 'nie głosuj na tą opcje bo będziesz miał koszmary.' do jej głosowania 'my-first-anon-poll'


INSERT INTO OPTIONS (
    name,
    min_value,
    max_value,
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    'nie głosuj na tą opcje bo będziesz miał koszmary.',
    4,
    4,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: dodać opcje 'Waniliowy' do jej głosowania 'my-first-anon-poll'

INSERT INTO OPTIONS (
    name,
    min_value,
    max_value,
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    'Waniliowy',
    5,
    5,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: dodać opcje 'Tajemna Opcja - nie ufaj readme.md' do jej głosowania 'my-first-anon-poll'

INSERT INTO OPTIONS (
    name,
    min_value,
    max_value,
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    'Tajemna Opcja - nie ufaj readme.md',
    7,
    10,
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

--================================================================

-- System pozwala Alicji: przypisać siebie jej głosowania 'my-first-anon-poll'

INSERT INTO MEMBERS (
    --x
    user_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    --x
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    --y
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: przypisać Adama jej głosowania 'my-first-anon-poll'

INSERT INTO MEMBERS (
    --x
    user_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    --x
    HEXTORAW('020340726a7434cb3cf0e4a32b546497079330145525d52c0fee38d48df384a282'),
    --y
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: przypisać Ewe jej głosowania 'my-first-anon-poll'

INSERT INTO MEMBERS (
    --x
    user_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    --x
    HEXTORAW('024e747154f1843e8e24b750e6ac3f96b9206ed98a7fa13585321031f1d8019fdb'),
    --y
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: przypisać Wiktora jej głosowania 'my-first-anon-poll'

INSERT INTO MEMBERS (
    --x
    user_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    --x
    HEXTORAW('03b7e0e0383a0908ab0c33fb6b00519ad78312c8f2a15e8d6ea8671f500e47eddd'),
    --y
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

-- System pozwala Alicji: przypisać Peggy jej głosowania 'my-first-anon-poll'

INSERT INTO MEMBERS (
    --x
    user_info_public_key,
    --y
    poll_user_info_public_key,
    poll_info_name
) VALUES (
    --x
    HEXTORAW('021435d498cbe86ad67a8b62b768197543e88f3330c054f358ad153ec5fb898b70'),
    --y
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

--================================================================

-- System (po weyfikacji podpisu) pozwala Alicji: aktywować jej głosowania 'my-first-anon-poll'

UPDATE POLLS
SET
    sign_poll = HEXTORAW('8675e94befe8293230856ddcc63e77e48ba916d8fa3ab1bd9674b65fe95b405a479c561320383c706b79be319ec9f026e59e296cef49e787bb6e91623faa7fb0')
WHERE
    user_info_public_key = HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
    AND
    info_name = 'my-first-anon-poll';

--================================================================

-- W tym momencie każda strona ma prawo odczytać pełne informacje na temat głosowania, może zweryfikować podpis Alicji całego głosowania (wstawiany do POLLS.sign_poll), oraz utworzyć wspólny skrót głosowania (wstawiany do MEMBERS.commit_poll).
-- Każda zangażowana strona ma również teraz dowód że Alicja potrafiła by stworzyć takie głosowanie. Ten dowód (w tym skrót głosowania (wstawiany do MEMBERS.commit_poll)), utrudniać jej będzie wycofanie głosowanie lub modyfikacje swej decyzji.

--================================================================

-- System (po weyfikacji podpisu) pozwala Alicji: dodać wpis do głosowania Alicji 'my-first-anon-poll'

UPDATE MEMBERS
SET
    --member's entry
    commit_array_index = 0,
    commit_hash = HEXTORAW('2b60bf8caa91452f000be587c441f6495f36def6fc4c36f5cc7b5d673f59fd0f'),
    commit_previous_entry = NULL,
    --member's sign
    sign_commit = HEXTORAW('e1d6d27d145119aa7536e686f754c8e4e03d726761a2c16d9baa4e1f76b74aff52a34c98a8648bb3fccd4e089c2fb08f458b92da7fdddf7c739e1257d9906cac'),
    --poll (constant)
    commit_poll = HEXTORAW('832f4e8e2ba8f691f1c48eee4d6fb502783d92b8a2a5a43efab5a7e4d40b07bb')
WHERE
    --x
    user_info_public_key = HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
    AND
    --y (constant)
    poll_user_info_public_key = HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
    AND
    poll_info_name = 'my-first-anon-poll';

-- System (po weyfikacji podpisu) pozwala Adamowi: dodać wpis do głosowania Alicji 'my-first-anon-poll'

UPDATE MEMBERS
SET
    --member's entry
    commit_array_index = 1,
    commit_hash = HEXTORAW('140334dcfb4589b8400596c7a38afa79bffa632068d75449d951d7efd5657b4b'),
    commit_previous_entry = HEXTORAW('df58cbf6e3e2077b0c466c1762a5a8f1f534cfeb50d185a98ea7d6030fd1b6fa'),
    --member's sign
    sign_commit = HEXTORAW('ab2e026f39028116f8e8aabb9ae5c9c38bac1fb1720faa1ba2520838cdd21da7014fa9b24356b6da226ef819a0ed279a7a1ea38a776d2683c65e779f0c3bd693'),
    --poll (constant)
    commit_poll = HEXTORAW('832f4e8e2ba8f691f1c48eee4d6fb502783d92b8a2a5a43efab5a7e4d40b07bb')
WHERE
    --x
    user_info_public_key = HEXTORAW('020340726a7434cb3cf0e4a32b546497079330145525d52c0fee38d48df384a282')
    AND
    --y (constant)
    poll_user_info_public_key = HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
    AND
    poll_info_name = 'my-first-anon-poll';

-- System (po weyfikacji podpisu) pozwala Ewie: dodać wpis do głosowania Alicji 'my-first-anon-poll'

UPDATE MEMBERS
SET
    --member's entry
    commit_array_index = 2,
    commit_hash = HEXTORAW('174df8621fc733b0bb409ba55c5e0b8bc7d00c97d5e43bdc2492ce23d0509ab6'),
    commit_previous_entry = HEXTORAW('8579da388999d677e8600ac9b9df319c116e2faad174a888e0307e3e57dee6d3'),
    --member's sign
    sign_commit = HEXTORAW('48bf2dc36874fe07f4e1c3971dde47753ae6886b7f430a318c7f3b213b4b27316480b61a64791984d42374f29379ba925a62c2e6a1727b6991344f921a7cef74'),
    --poll (constant)
    commit_poll = HEXTORAW('832f4e8e2ba8f691f1c48eee4d6fb502783d92b8a2a5a43efab5a7e4d40b07bb')
WHERE
    --x
    user_info_public_key = HEXTORAW('024e747154f1843e8e24b750e6ac3f96b9206ed98a7fa13585321031f1d8019fdb')
    AND
    --y (constant)
    poll_user_info_public_key = HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
    AND
    poll_info_name = 'my-first-anon-poll';

-- System (po weyfikacji podpisu) pozwala Wiktorowi: dodać wpis do głosowania Alicji 'my-first-anon-poll'

UPDATE MEMBERS
SET
    --member's entry
    commit_array_index = 3,
    commit_hash = HEXTORAW('0f852e5daef034a7eae929fe437bf6bfef909eb389c193d41b00114ac341820f'),
    commit_previous_entry = HEXTORAW('f3ccaf43d45ff11ec76bd72ec3935e4ebc1aceebab69869b2445072c3008fda0'),
    --member's sign
    sign_commit = HEXTORAW('36db32d9bd5bc8c037a61a7f855b517bbfa773698bbc3dbd9485f45479ddea395e58122cf3d32d3290490cf74e3c74c998359d5b1c05124cf94d3ce9b6deb62f'),
    --poll (constant)
    commit_poll = HEXTORAW('832f4e8e2ba8f691f1c48eee4d6fb502783d92b8a2a5a43efab5a7e4d40b07bb')
WHERE
    --x
    user_info_public_key = HEXTORAW('03b7e0e0383a0908ab0c33fb6b00519ad78312c8f2a15e8d6ea8671f500e47eddd')
    AND
    --y (constant)
    poll_user_info_public_key = HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
    AND
    poll_info_name = 'my-first-anon-poll';

-- System (po weyfikacji podpisu) pozwala Peggy: dodać wpis do głosowania Alicji 'my-first-anon-poll'

UPDATE MEMBERS
SET
    --member's entry
    commit_array_index = 4,
    commit_hash = HEXTORAW('0468012e40090ed67c8d7d9456dbbd16da4dadd27c092886fd246b284eafdcfb'),
    commit_previous_entry = HEXTORAW('9b68b1978455300eff2de12b35fd26048bb5d1f2ef8c7075d6b14ed95eae0977'),
    --member's sign
    sign_commit = HEXTORAW('6d7148b6cc90cbd791b3ddb01dba3da6d521b33301b52c560f1702c72eb7e44e2bb023914ab2cd4858d58c0ea1002eb39cddff3209e1db7163d94ccb2a6c33b2'),
    --poll (constant)
    commit_poll = HEXTORAW('832f4e8e2ba8f691f1c48eee4d6fb502783d92b8a2a5a43efab5a7e4d40b07bb')
WHERE
    --x
    user_info_public_key = HEXTORAW('021435d498cbe86ad67a8b62b768197543e88f3330c054f358ad153ec5fb898b70')
    AND
    --y (constant)
    poll_user_info_public_key = HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426')
    AND
    poll_info_name = 'my-first-anon-poll';

--================================================================

-- W tym momencie wszyscy członkowie głosowania Alicji 'my-first-anon-poll' utworzyli pełną tablice wpisów. Z tej tablicy można wyznaczyć wspólny skrót który jest używany do utworzenia dowodu zerowej wiedzy. Jako że w dowodzie brany będzie pod uwagę zawszę tylko 1 element z tej tablicy, to optymalną strukturą służącą do wyznaczenia skrótu z tej tablicy jest Merkle Tree (Nie musi być to wymogiem).

-- Warto zaznaczyć że taki skrót może być zmienny jeśli pozwolone jest na dalszą modyfikację tablicy wpisów.

--================================================================

-- System otrzymuje wiadomość twierdzącą że jest głosem do głosowania Alicji o nazwie 'my-first-anon-poll'.
-- System z wiadomości odczytuje i werifikuje:
-- -- dowód (przeciwko aktualnym wpisom z tego głosowania (poprzez Merkle Root)).
-- -- referencje do poprzedniego oddanego głosu.
-- -- czy głos pasuje do odpowiedzi za którą się podaje pasować. (opcjonalne)
-- -- -- Głos pasuje do opcji "Waniliowy".
-- Tajemnice:
-- -- Głos stworzyła Ewa.

INSERT INTO VOTES (
    --public signals
    vote_value,
    vote_entries_root,
    vote_nullifier,
    vote_previous_vote,
    --proof
    proof_vote,
    --x
    poll_user_info_public_key,
    poll_info_name,
    --y (optional)
    option_name,
    option_info_public_key,
    option_info_name
) VALUES (
    --public signals
    UTL_RAW.CAST_FROM_BINARY_INTEGER(5),
    HEXTORAW('2d03b1877636458a8f9fda78d8d63a44b67e07239b0f54d6092546f13c5a718b'),
    UTL_RAW.CAST_FROM_BINARY_INTEGER(357),
    NULL,
    --proof
    '
        Proof:  {
            pi_a: [
                ''7456716481124659950509027749823111439967119224999623128666054978646669623693'',
                ''12867528627647035972917425175769377212605693550290147798522133006584018793450'',
                ''1''
            ],
            pi_b: [
            [
                ''12274876802892825536200518468454710630706862687146687087342056139368249113458'',
                ''662538945601097333347314948361140670632185400857868291234807497603827606455''
            ],
            [
                ''5761401589575314823860779859900729754580404160730226104986056854650452693433'',
                ''15882391798219619377345702854890739713831294419411971955398517664014168352605''
            ],
            [ ''1'', ''0'' ]
            ],
            pi_c: [
                ''9150254738269055018421174969301494840305535769112263271389375157610088324272'',
                ''2357319119627052614714378919254195791616588974621564076598381317980255952926'',
                ''1''
            ],
            protocol: ''groth16'',
            curve: ''bn128''
        }
    ',
    --x
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll',
    --y (optional)
    'Waniliowy',
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

--================================================================

-- System otrzymuje wiadomość twierdzącą że jest głosem do głosowania Alicji o nazwie 'my-first-anon-poll'.
-- System z wiadomości odczytuje i werifikuje: ..
-- -- -- Głos pasuje do opcji "nie wiem, ale napewno dobry.".
-- Tajemnice:
-- -- Głos stworzyła Peggy.

INSERT INTO VOTES (
    --public signals
    vote_value,
    vote_entries_root,
    vote_nullifier,
    vote_previous_vote,
    --proof
    proof_vote,
    --x
    poll_user_info_public_key,
    poll_info_name,
    --y (optional)
    option_name,
    option_info_public_key,
    option_info_name
) VALUES (
    --public signals
    UTL_RAW.CAST_FROM_BINARY_INTEGER(3),
    HEXTORAW('2d03b1877636458a8f9fda78d8d63a44b67e07239b0f54d6092546f13c5a718b'),
    UTL_RAW.CAST_FROM_BINARY_INTEGER(18),
    HEXTORAW('2fca57749ab98db515908cbd0c2851186d948241959b42b394a576763e83774f'),
    --proof
    '
        Proof:  {
            pi_a: [
                ''19214662446847614726307124147241137523628783728849910787628953923176893842074'',
                ''13522600439169260269092321174820469746853640370816801351776971013011856774692'',
                ''1''
            ],
            pi_b: [
            [
                ''8854447574722544804681750239833939071323986602876884218196139203094058060250'',
                ''19375976840536401153477478663190495794010865186636786622334560129095187274217''
            ],
            [
                ''5628196813012863736040099900101491927658435373692586940291610046030557794875'',
                ''2354350681778172883597199595425962670327575658216259448628752445141724309884''
            ],
            [ ''1'', ''0'' ]
            ],
            pi_c: [
                ''20087165419424693623414231129057051414942860835658786943041849260732717129181'',
                ''6383726196582619140992509560779177343238290484115375568366521489724680509362'',
                ''1''
            ],
            protocol: ''groth16'',
            curve: ''bn128''
        }
    ',
    --x
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll',
    --y (optional)
    'nie wiem, ale napewno dobry.',
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

--================================================================

-- System otrzymuje wiadomość twierdzącą że jest głosem do głosowania Alicji o nazwie 'my-first-anon-poll'.
-- System z wiadomości odczytuje i werifikuje: ..
-- -- -- Głos pasuje do opcji "Pomarańczowy".
-- Tajemnice:
-- -- Głos stworzył Adam.

INSERT INTO VOTES (
    --public signals
    vote_value,
    vote_entries_root,
    vote_nullifier,
    vote_previous_vote,
    --proof
    proof_vote,
    --x
    poll_user_info_public_key,
    poll_info_name,
    --y (optional)
    option_name,
    option_info_public_key,
    option_info_name
) VALUES (
    --public signals
    UTL_RAW.CAST_FROM_BINARY_INTEGER(1),
    HEXTORAW('2d03b1877636458a8f9fda78d8d63a44b67e07239b0f54d6092546f13c5a718b'),
    UTL_RAW.CAST_FROM_BINARY_INTEGER(654),
    HEXTORAW('19b93e23249980d20ca73527c1a064ce80e0c0cb24a37adb224422f0a339aafb'),
    --proof
    '
        Proof:  {
            pi_a: [
                ''11231446296647509913794553670694148641632532181753547613796723868721058088381'',
                ''10661940433115121261648029364688337610616901233534083599755050522178145167905'',
                ''1''
            ],
            pi_b: [
            [
                ''18000986517910164435475391488913449271834424589522520327424872780587401801874'',
                ''4338197605237898238724981902503734988218411373868344897437722910620141419127''
            ],
            [
                ''9729738128079901156591993537167654379107476187804992859423098539391446733901'',
                ''10511831223006219765701039808011303486100461822980248465197704077500517292296''
            ],
            [ ''1'', ''0'' ]
            ],
            pi_c: [
                ''19806447765597768406886696588823506308764027984059822916968974477453398237662'',
                ''20935420662381021762001237898919590119861972445489650872565103114374938209000'',
                ''1''
            ],
            protocol: ''groth16'',
            curve: ''bn128''
        }
    ',
    --x
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll',
    --y (optional)
    'Pomarańczowy',
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

--================================================================

-- System otrzymuje wiadomość twierdzącą że jest głosem do głosowania Alicji o nazwie 'my-first-anon-poll'.
-- System z wiadomości odczytuje i werifikuje: ..
-- -- -- Głos pasuje do opcji "Waniliowy".
-- Tajemnice:
-- -- Głos stworzyła Alicja.

INSERT INTO VOTES (
    --public signals
    vote_value,
    vote_entries_root,
    vote_nullifier,
    vote_previous_vote,
    --proof
    proof_vote,
    --x
    poll_user_info_public_key,
    poll_info_name,
    --y (optional)
    option_name,
    option_info_public_key,
    option_info_name
) VALUES (
    --public signals
    UTL_RAW.CAST_FROM_BINARY_INTEGER(5),
    HEXTORAW('2d03b1877636458a8f9fda78d8d63a44b67e07239b0f54d6092546f13c5a718b'),
    UTL_RAW.CAST_FROM_BINARY_INTEGER(456),
    HEXTORAW('084ea7db04fac878a5fede67ac93adbb6346eba0033a46bd9fc3c666724d4de4'),
    --proof
    '
        Proof:  {
            pi_a: [
                ''7578483591381076706252810815242419246088117844058589405421689731862292687535'',
                ''13274503974129161219417127740763602766298737793291077735508110193944066051537'',
                ''1''
            ],
            pi_b: [
            [
                ''10696145016025012846418594800332156087989556139564815235367919326551521377221'',
                ''5189311616136497197419019199028630521228641517806959542389324828459023059468''
            ],
            [
                ''5161871448741274117461153184404795655405629089661244197773775050079956075205'',
                ''20660751655263444107855864336459740382220844158441440503071713351829525645972''
            ],
            [ ''1'', ''0'' ]
            ],
            pi_c: [
                ''5223300377319316852112919038015968805217028671696002856333443254254898526583'',
                ''15520643780610599636489151074561733541300917267115840557734701759243512978761'',
                ''1''
            ],
            protocol: ''groth16'',
            curve: ''bn128''
        }
    ',
    --x
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll',
    --y (optional)
    'Waniliowy',
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);

--================================================================

-- System otrzymuje wiadomość twierdzącą że jest głosem do głosowania Alicji o nazwie 'my-first-anon-poll'.
-- System z wiadomości odczytuje i werifikuje: ..
-- -- -- Głos pasuje do opcji "Waniliowy".
-- Tajemnice:
-- -- Głos stworzył Wiktor.

INSERT INTO VOTES (
    --public signals
    vote_value,
    vote_entries_root,
    vote_nullifier,
    vote_previous_vote,
    --proof
    proof_vote,
    --x
    poll_user_info_public_key,
    poll_info_name,
    --y (optional)
    option_name,
    option_info_public_key,
    option_info_name
) VALUES (
    --public signals
    UTL_RAW.CAST_FROM_BINARY_INTEGER(5),
    HEXTORAW('2d03b1877636458a8f9fda78d8d63a44b67e07239b0f54d6092546f13c5a718b'),
    UTL_RAW.CAST_FROM_BINARY_INTEGER(11),
    HEXTORAW('16da5378aa311afd74dc8f87c0c0198f5165c6a645f4ec291c0b15daac966e8d'),
    --proof
    '
        Proof:  {
            pi_a: [
                ''6579768207168992275960395332553907387459136904149846669843341641152984394728'',
                ''19513128315558733400679493517326443959054440159947880504796049173437453455452'',
                ''1''
            ],
            pi_b: [
            [
                ''17567333708405009156459909241387168429421030166073663848262006750345303628540'',
                ''6926438840823708948710608994475699940388559065774755823970689164742451744037''
            ],
            [
                ''20372164667392994037958169695528389446223222139460300264691626630342377558821'',
                ''20913223004505397352067402841778863017107833772659301503795807283800669244701''
            ],
            [ ''1'', ''0'' ]
            ],
            pi_c: [
                ''20106978346511674478517330523081705756084761129676728075186374129188854382269'',
                ''2773626474865952526614450928215282800181536879967642534658857478269690096326'',
                ''1''
            ],
            protocol: ''groth16'',
            curve: ''bn128''
        }
    ',
    --x
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll',
    --y (optional)
    'Waniliowy',
    HEXTORAW('0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426'),
    'my-first-anon-poll'
);