# Registrazione Utente

### Descrizione

La registrazione si completa in due fasi:

* Registazione
* Attivazione

## Registazione

Crea un utente `non attivo` in stato `non verificato`. Invia una mail all'indirizzo specificato dall'utente per la procedura di registrazione e una notifica via mail all'indirizzo dell'account.

Esistono due template per la mail di registrazione:

1. Con codice attivazione (mobile)
  * Escludendo `callback_url` dal corpo del messaggio HTTP
2. Con link alla pagina di attivazione (web)
  * Includendo `callback_url` nel corpo del messaggio HTTP
  * il codice attivazione viene appeso all'url `callback_url`

> Esempio

```shell

# cURL

curl
  -X POST
  -d '{"user": {
        "email": "test@example.com",
        "password": "secret123",
        "password_confirmation": "secret123",
        "callback_url": "https//mio.sito.com/user/activate (opzionale)",
        "profile": {
          "first_name": "nome",
          "last_name": "congome",
          "fiscal_code": "codice fiscale",
          "date_of_birth": "data di nascita (yyyy-mm-dd)",
          "place_of_birth": "luogo di nascita",
          "phone_number": "numero di telefono",
          "profession": "professione",
          "specialization": "specializzazione",
          "board_member": "iscrizione ordine",
          "board_number": "numero iscrizione",
          "province_board": "provincia iscrizione",
          "employment": "attività lavorativa",
          "province_enployment": "provincia attività lavorativa"
        }
      }'
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/user/signup
```

```ruby
# Ruby

require 'httparty'

HTTParty.post('https://api.dardy.me/sso/user/signup',
  body: '{"user": {
          "email": "test@example.com",
          "password": "secret123",
          "password_confirmation": "secret123",
          "callback_url": "https//mio.sito.com/user/activate (opzionale)",
          "profile": {
            "first_name": "nome",
            "last_name": "congome",
            "fiscal_code": "codice fiscale",
            "date_of_birth": "data di nascita (yyyy-mm-dd)",
            "place_of_birth": "luogo di nascita",
            "phone_number": "numero di telefono",
            "profession": "professione",
            "specialization": "specializzazione",
            "board_member": "iscrizione ordine",
            "board_number": "numero iscrizione",
            "province_board": "provincia iscrizione",
            "employment": "attività lavorativa",
            "province_enployment": "provincia attività lavorativa"
          }
        }',
  headers: {
    'Accept' => 'application/vnd.dardy.sso.v1+json',
    'Content-Type' => 'application/json',
    'Authorization' => 'Dardy <jwt>'
  }
)
```

```javascript
// jQuery

$.ajax({
  type: "POST",
  url: "https://api.dardy.me/sso/user/signup",
  data: '{"user": {' +
          '"email": "test@example.com",' +
          '"password": "secret123",' +
          '"password_confirmation": "secret123",' +
          '"callback_url": "https//mio.sito.com/user/activate (opzionale)",' +
          '"profile": {' +
            '"first_name": "nome",' +
            '"last_name": "congome",' +
            '"fiscal_code": "codice fiscale",' +
            '"date_of_birth": "data di nascita (yyyy-mm-dd)",' +
            '"place_of_birth": "luogo di nascita",' +
            '"phone_number": "numero di telefono",' +
            '"profession": "professione",' +
            '"specialization": "specializzazione",' +
            '"board_member": "iscrizione ordine",' +
            '"board_number": "numero iscrizione",' +
            '"province_board": "provincia iscrizione",' +
            '"employment": "attività lavorativa",' +
            '"province_enployment": "provincia attività lavorativa"' +
          '}' +
        '}',
  headers: {
    "Accept": "application/vnd.dardy.sso.v1+json",
    "Content-Type": "application/json",
    "Authorization": "Dardy <jwt>"
  }
});
```

> Ritorna un JSON strutturato come segue:

```json
{
  "user": {
    "id": 37,
    "status": "unverified",
    "email": "test@example.com",
    "active": false,
    "profile": {
      ...
    }
  }
}
```

**Nota**

Per utilizzare questo endpoint è necessario creare una [sessione](#sessione).

### Richiesta HTTP

`POST https://api.dardy.me/sso/user/signup`

### Headers HTTP

`Accept: application/vnd.dardy.sso.v1+json`

`Authorization: Dardy <jwt>`

<aside class="warning">
  Sostituire <code>&lt;jwt&gt;</code> con il token presente nell'header della risposta alla chiamata di sessione.
</aside>

### Codici risposta HTTP

Codice | Descrizione
-------| -------
201 | Created -- La richiesta è andata a buon fine
404 | Not Found -- Codice di attivazione non valido
422 | Unprocessable Entity -- Errore di validazione

## Attivazione

Invia la richiesta di attivazione.

> Esempio

```shell

# cURL

curl
  -X PUT
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/user/activate/<activation-code>
```

```ruby
# Ruby

require 'httparty'

HTTParty.put('https://api.dardy.me/sso/user/activate/<activation-code>',
  headers: {
    'Accept' => 'application/vnd.dardy.sso.v1+json',
    'Content-Type' => 'application/json',
    'Authorization' => 'Dardy <jwt>'
  }
)
```

```javascript
// jQuery

$.ajax({
  type: "PUT",
  url: "https://api.dardy.me/sso/user/activate/<activation-code>",
  headers: {
    "Accept": "application/vnd.dardy.sso.v1+json",
    "Content-Type": "application/json",
    "Authorization": "Dardy <jwt>"
  }
});
```

> Ritorna un JSON strutturato come segue:

```json
{
  "user": {
    "status": "unverified",
    "id": 37,
    "email": "test@example.com",
    "active": true
  }
}
```

**Nota**

Per utilizzare questo endpoint è necessario creare una [sessione](#sessione).

### Richiesta HTTP

`POST https://api.dardy.me/sso/user/activate/<activation-code>`

### Headers HTTP

`Accept: application/vnd.dardy.sso.v1+json`

`Authorization: Dardy <jwt>`

<aside class="warning">
  Sostituire <code>&lt;jwt&gt;</code> con il token presente nell'header della risposta alla chiamata di sessione.
</aside>

<aside class="info">
  Sostituire <code>&lt;activation-code&gt;</code> con il codice di attivazione fornito dall'utente che ha ricevuto la mail
</aside>

### Parametri

Parameter | Description
--------- | -----------
&lt;activation-code&gt; | Codice di attivazione fornito dall'utente che ha ricevuto la mail

### Codici risposta HTTP

Codice | Descrizione
------------- | -------
200 | Success -- La richiesta è andata a buon fine
404 | Not Found -- Codice di attivazione non valido
422 | Unprocessable Entity -- Errore di validazione