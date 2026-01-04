
1. ***Użytkownik*** ->  `user`
    - `public_key` - standard `secpk256k1` (65 znaków)
    - `profile_name`
    - `sign_profile`
    - `permissions`
    - `father`*
2. ***Głosowanie*** ->  `poll`
3. ***Załączniki*** ->  `attachment`
4. ***Uczestnik***  ->  `member`
5. ***Wpisy***      ->  `entry`
6. ***Głosy***      ->  `vote`
7. ***Opcje***      ->  `option`

***Użytkownik*** tworzy ***Głosowanie***
***Głosowanie***:
    - Ma ***Załączniki***
    - Ma swych ***Uczestników***
        - Którzy tworzą pojedyńcze ***Wpisy***
    - Ma ***Głosy***
    - Ma ***Opcje*** (lub nie w zależności `rodzaju głosowania`)