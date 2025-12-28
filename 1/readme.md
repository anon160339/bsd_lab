# Modelowana rzeczywistość

Modelowana będzie teoretyczna baza danych służąca do przeprowadzania anonimowych głosowań studentów politechniki. Serwis ma odzwierciedlać system w którym zaufanie do serwisu i innych użytkowniów względem studenta jest jak najmniej potrzebne.

# Pochodzenie encji

## Głosowanie

### Schemat:

1. ***Użytkownik*** tworzy ***głosowanie*** z jawnymi parametrami, jawnie przypisanymi do niego ***uczestnikami*** oraz jawnymi ***załącznikami***, z którego ***uczestnicy*** oraz serwis mogą odczytać stały `hash głosowania`.
2. ***Uczestnicy*** jawnie tworzą pojedyńcze ***wpisy*** dla danego ***głosowania***, tworzące poindeksowaną `tablice wpisów`. Każdy element tej tablicy to hash wynikający z pary tajnych parametrów `s` i `k` (`hash = H(s, k)`).
3. Anonimowe źródła dostarczają do serwisu ***głosy*** zawierające w sobie dowód który:
    - Wiąże jawną `wiadomość` będącą wyborem przez ***Uczestnika***.
    - Wiąże jawny `hash głosowania` wynikający z ***głosowania***, ***uczstników*** i ***załączników***.
    - Udowadnia zawarcie takich elementów tablicy oraz takiej pary `s` i wiążącego jawnie `k`, które tworzą identyczną `tablice wpisów` jaką serwis dysponuje w danym momencie. *(`tablica wpisów` może okazać się wielka, dlatego skrócić ją można poprzez strukture Merkle Tree)*.
4. Jeśli dowód jest prawdziwy, to ***głos*** zostaje zostaje w zapisany do bazy danych.
    - Możliwość sprawdzenia ***głosów*** przez ***uczestników*** pozwala im skontrolować ucziwość serwisu.
5. ***Głosy***

## Potencjalna realizacja

### Interfejs użytkowników

### Dowodzenie

## Czy można lepiej?

Moja wiedza i doświadczenie nie potrafi odpowiedzieć na to pytanie, lecz intuicja mi sygnalizuje że jeśli istnieją systemy głosowań w których głosy potrafią homomorficznie się "dodawać", lub klucze publiczne służą do tworzonia "jednorazowych" kluczy, to można by się zastanawiać nad optymalizacją procesu oddawania głosów.

### Problemy obecnego systemu

- Cenzura - Serwis może odrzucać głosy. Rowzwiązanie szukać można poprzez decentalizacje serwisu.
- Brak konceptu "stealth address"'ów - Użytkownicy mogą jawnie oddawać głosy
- Modyfikowalność `tablicy wpisów` - ***wpisy*** wstawiane są w sposób który umożliwia łatwe ich usunięcie. Łatwym rozwiązaniem jest zastosowanie struktury podobnej do blockchain'a.