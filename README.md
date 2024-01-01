# Aplikacja Czat

To repozytorium zawiera prostą aplikację czatową z frontendem we Flutterze oraz backendem we Flasku.



## Stan na 01.01.23

Na dzień obecny, aplikacja czatowa obsługuje podstawowe funkcje rejestracji, logowania i wymiany wiadomości. Interfejs użytkownika do czatu jest minimalistyczny, wiadomości są wyświetlane na liście. Użytkownicy mogą wysyłać wiadomości, które następnie są dodawane do bazy danych SQLite na backendzie. Wiadomości są pobierane i wyświetlane w interfejsie czatu.

### Prace Przyszłe

    Implementacja autentykacji użytkownika z sesjami opartymi na tokenach.
    Zmiana funkcji get i send_message na dane zalogowanego użytkownika zamiast statycznych ID.
    Implementacja założonych błędów i naprawa ich.
## Backend

Backend został zbudowany przy użyciu Flask oraz SQLite jako bazy danych. Zapewnia REST API do rejestracji użytkowników, logowania, wysyłania wiadomości i ich odbierania.

### Konfiguracja

Aby skonfigurować backend, upewnij się, że masz zainstalowanego Pythona, a następnie uruchom następujące polecenia:

```bash
python -m pip install -r requirements.txt
```

Ustaw zmienne środowiskowe:
```bash
DATABASE_URL=sqlite:///chat.db
FLASK_APP=app.py
FLASK_RUN_HOST=0.0.0.0
```
Uruchom aplikację Flask za pomocą poniższego polecenia terminala bądź przy pomocy IDE:

```bash
flask run
```

Baza danych (chat.db) jest automatycznie tworzona przy starcie aplikacji.

Endpointy

    POST /register: Rejestruje nowego użytkownika z nazwą użytkownika i hasłem. (nie zaimplementowane/nie testowane)
    POST /login: Uwierzytelnia użytkownika (nie zaimplementowanie/nie testowane)
    POST /send-message: Wysyła wiadomość od jednego użytkownika do drugiego (na razie ID uzytkownika na sztywno w kodzie)
    GET /get-messages: Pobiera wiadomości dla użytkownika (na razie ID uzytkownika na sztywno w kodzie)

Modele

    User: Reprezentuje użytkownika z nazwą użytkownika i hasłem.
    Message: Reprezentuje wiadomość z treścią, identyfikatorem nadawcy, identyfikatorem odbiorcy i znacznikiem czasu.

## Frontend

Frontend to aplikacja Flutterowa, która zapewnia interfejs użytkownika do rejestracji użytkowników, logowania, wysyłania wiadomości i przeglądania ich.

### Konfiguracja

Aby skonfigurować frontend, upewnij się, że masz zainstalowany Flutter, a następnie uruchom następujące polecenia:

```bash
flutter pub get
flutter run
```

Zamień ip z pliku /lib/config.dart na swoje, jest to adres API Flaska:
``` javascript
  static const String serverAddress = 'http://192.168.0.175:5000';
```

### Funkcje

    Rejestracja i logowanie użytkownika.
    Interfejs czatu w czasie rzeczywistym.
    Automatyczne pobieranie i wyświetlanie wiadomości.
    Przewijanie widoku wiadomości.

![login_screen.png](https://github.com/D-Jonczyk/BAM-projekt-czat/blob/main/images/login_screen.png "Okno logowania")


![chat.png](https://github.com/D-Jonczyk/BAM-projekt-czat/blob/main/images/chat.png "Panel czatu")


### Widgety

    ChatScreen: Główny ekran aplikacji, na którym użytkownicy mogą wysyłać i przeglądać wiadomości.
