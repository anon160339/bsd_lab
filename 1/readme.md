# Modelowana rzeczywistość

Modelowana będzie teoretyczna baza danych służąca do przeprowadzania anonimowych głosowań. Serwis tej bazy danych ma odzwierciedlać system w którym zaufanie do dowlnej strony jest jak najmniej potrzebne.

# Pochodzenie encji

## Główny schemat głosowania:

1. ***Użytkownik*** tworzy ***głosowanie*** z jawnymi parametrami, jawnie przypisanymi do niego ***uczestnikami*** oraz jawnymi ***załącznikami*** i jawnymi ***opcjami***, z którego ***uczestnicy*** oraz serwis mogą odczytać stały `hash głosowania` (wiążący te elementy).
2. ***Uczestnicy*** jawnie tworzą pojedyńcze ***wpisy*** dla danego ***głosowania***, tworzące poindeksowaną `tablice wpisów`. Każdy element tej tablicy zawiera hash wynikający z pary tajnych parametrów `s` i `k` (tak zwany "nullifier") (`hash = H(s, k)`).
    - Aby utrudnić bazie danych modyfikacje elmentów `tablicy wpisów`, można interpretować elementy tej tablicy jako bloki, gdzie każdy blok odnosi się do o 1 starszego bloku, tworząc tak zwany "blockchain". Dlatego każdy ***wpis*** powinien wiązać poprzedni zarejestrowany ***wpis***.
    - Aby utrudnić zmianę samego opisu głosowania (Nie mieć zaufania do Autora i Serwisu) każdy wpis powinien wiąząć jawny `hash głosowania` wynikający z ***głosowania***, ***załączników***, ***opcji*** i opcjonalnie ***uczstników*** *(Jest to bez znaczenie gdy strona właściciela głosowania jest stroną serwisu.) (Uporządkowany zbiór ***uczestników*** można otrzymać poprzez ich posortowanie.)*.
3. Anonimowe źródła dostarczają do serwisu ***głosy*** zawierające w sobie dowód (zerowej wiedzy) który:
    - Wiąże jawną `wiadomość` będącą wyborem przez ***Uczestnika***.
    - Udowadnia zawarcie takich elementów tablicy oraz takiej pary `s` i wiążącego jawnie `k`, które tworzą identyczną `tablice wpisów` jaką serwis dysponuje w danym momencie. *(`tablica wpisów` może okazać się wielka, dlatego skrócić ją można poprzez strukture* **Merkle Tree** *, oraz dalsze dowodzenie przez* **Merkle Proof** *który udowadnia występowanie elemntu w tablicy o danym skrócie.)*
    - Pownien wiąząć poprzedni oddany głos tworząc strukturę łańcuchową typu "blockchain", w celu utrudnienia usunięcia głosów zakceptowanych przez serwis.
4. Jeśli dowód jest prawdziwy i powiązane z nim jawne wartości pokrywają się z aktualnym stanem `tablicy wpisów`, to ***głos*** zostaje tylko raz zapisany do bazy danych. (nie mogą istnieć 2 głosy o takim samym `k`)
    - Możliwość sprawdzenia ***głosów*** przez ***uczestników*** pozwala im skontrolować ucziwość serwisu.

*Wszystkie wymienione wyżej obiekty bazo danowe są praktycznie jawnie.*
*Do tego należy uwzględnić dodatkowe parametry jak możliwe wartości głosów, czy podpisy gwarantujące poprawne pochodzenie od uczestnika.*

### Inspiracja

Niemal identyczny system został zaimplementowany w narzędziu [Tornado Cash](https://github.com/tornadocash) służącym do anonimizacji pochodzenia kapitału, operującego na kryptowalutach na wielu sieciach. (*Zamiast `adresu` na który mają być wysłane pieniądze ze skarbca, wstawiłem `wiadomość` głosu.*)

### Wyjaśnienie ***wpisu***

- Para `s` i `k` to odpowiednio sekret i "nullifier". Udowodnienie znajomości takiego `s` przy jawnych paramtrach `k`, `H`, `c` i które spełnia warunek `H(s, k) === c` można interpretować jako jednorazowy klucz OTP (one time pad).
    - Dowód zerowej wiedzy opisany w punkcie 3, ujawniając `k` jednocześnie identyfikuje ze sobą ukryty w dowodzie `H(s, k)` który w otoczeniu innych elementów dalej nie ujawnia ani `s`, ani `H(s, k)`, co utrudnia asocjacje `k` z ***wpisem***. (Każdy dowód w ten sposób wygenorowany będzie miał dokładnie ten sam `k`)

### Ograniczenia systemu

Ograniczenia:
- ***Uczestnicy*** po oddaniu ***wpisu*** powinni poczekać aż pozostali użytkownicy oddadzą swoje ***wpisy*** aby ***głosy*** nie mogły być zasocjowane z małą grupą ***wpisów*** których autorami są pojedyńczy ***uczestnicy***. 
- Każdy dowód ***głosu*** powstaje z aktualnej `tablicy wpisów` co czyni tworzenie, weryfikacje i wstawianie dowodu (***głosu***) do bazy danych zależne od stau bazy danych. Przetwarzanie nie może dokonywać się w sposób równoległy.
    - *Aby ***głos*** był weryfikowalny przez każdą zangażowaną stronę w dowolnym momencie, dowód zerowej wiedzy należało by porównywać z stanem `tablicy wpisów` który był użyty podczas wstawiania ***głosu***. Dlatego przydatne (choć nie jest to konieczne) było by kojarzenie ***głosu*** z danym stanem `tablicy wpisów` (np: poprzez aktualny rozmiar tej tablicy).*

## Dodatkowe Obostrzenia

- Każda operacja danego użytkownika musi być kryptograficznie przez niego podpisana i weryfikowalna przez stronę której ona dotyczy.
    - Gwarantuje że akcje użytkownika pochodzą bezpośrednio od niego, a serwis się pod niego nie podszywa.
- ***Wpisy*** i ***Głosy*** muszą tworzyć łańcuch w którym to każda instancja wiąże ze sobą instancje o 1 młodszą w ich posortowanym ciągu.
    - Utrudnia odrzucenie lub modyfikacje elementów starszych niż najmłodszy.

# Potencjalna realizacja

## Serwer

### Front-end

- Interfejs użytkownika: HTML, CSS, JS (wykonuje kod imperatywny, i zarządza lub generuje sekrety)

### Back-end

- Przetwarzanie danych: PHP, Ruby, NodeJS, Java, C++, Rust, etc...
- Baza danych: Relacyjna baza danych.

## System podpisów

System podpisów może być realizowany na przykład przez:
- ECC signature scheme (ECDSA), RSA, ElGamal (*Krótki popis*)
- SPHINCS+ (*Długi podpis*).

## Dowody

Stworzenie dowodu który spełnia oczekiwania wymienione w punktach 3 i 4, może być trudną do wykonania rzeczą w sposób czysto matematyczny, dlatego można też go stworzyć poprzez:
- Dowody zobowiązań tworzące układ relacji między zobowiązaniami. (np: [System zobowiązań Pedersen'a](https://www.zkdocs.com/docs/zkdocs/commitments/pedersen/))
- Systemy kryptograficzne zabezpieczejące relacje między wstawionymi wartościami. (np: zkSNARK)

# Czy można lepiej?

Moja wiedza i doświadczenie nie potrafi odpowiedzieć na to pytanie, lecz intuicja mi sygnalizuje że jeśli istnieją systemy głosowań w których głosy potrafią homomorficznie się "dodawać", lub klucze publiczne służą do tworzonia "jednorazowych" kluczy, to można by się zastanawiać nad optymalizacją procesu oddawania głosów.

## Problemy obecnego systemu

- Cenzura - Serwis może odrzucać głosy.
    - *Rowzwiązanie szukać można poprzez decentalizacje serwisu.*
- "Wulgarność" dowodów - Wybrana `wiadomość` z dowodu może przyjmować wulgarne treści.
    - *Rozwiązać to można poprzez obostrzenia jak na przykład zagwarantowanie w dowodzie aby `wiadomość` przyjmowała odpowiednie wartości. (np: liczby inne niż 69)*
- Brak konceptu "stealth address"'ów - ***Uczestnicy*** widzą innych ***uczestników*** przypisanych do danego ***głosowania***.
- **Tworzenie ***wpisów*** - Jest to dodatkowy proces który ujawnia kto nie wział udziału w głosowaniu.**
- Czasowość dowodów - Tworzenie i weryfikacja dowodu są zależne od aktualnej `tablicy wpisów`.
    - *Jeśli ***wpis*** był by jawnie generowalną lub jawnie jednorazową częścią ***uczestnika*** to `tablica wpisów` nie ulagała by zmianie (bo jej zawartość była by deterministyczna (tablica od razu wypełniona)), co czyniło by przetwarzanie niezależne od stanu tej tablicy, oraz gwarantowało by pełną anonimizacje uczestników.*
- Kolizje "nullifer"'ów. - Mogą istnieć takie `c1 = H(s_1,k_1)` i `c2 = H(s_2,k_2)` że `k_1 = k_2`.
