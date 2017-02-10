---
title: Documentazione API SSO

language_tabs:
  - shell
  - ruby
  - javascript

toc_footers:
  - <a href='https://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduzione

SSO è un sistema di autenticazione centralizzato per web e mobile.
Espone servizi (endpoints) in modalità REST per la registrazione, autenticazione e notifiche mail.

Gli account registrati che intendono aderire al sistema di autenticazione hanno a disposizione le seguenti funzionalità.

* Sessione account
* Registrazione utente (double opt-in)
* Autenticazione utente
* Cambio password (double opt-in)
* Aggiornamento profilo utente

Il codice di esempio compare sul lato destro di questa pagina. Per cambiare il
client utilizzato cliccare sui tab in alto a destra.

# Sessione

```shell
# Per creare una sessione

curl -i
  -X POST
  -d '{"account": {
        "access_key": "<access_key>",
        "secret_key": "<secret_key>"
      }
    }'
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  https://api.dardy.me/sso/session
```

> Ritorna un JSON strutturato come segue:

```json
{
  "account":
  {
    "id":2,
    "app_name": "Test",
    "active": true,
    "access_key": "<access_key>"
  }
}
```

### Descrizione

SSO usa chiavi di accesso per l'utilizzo dele API. Per richiedere le chiavi di accesso contattare il provider Dardy.

### Richiesta HTTP

`POST https://api.dardy.me/sso/session`

### Headers HTTP

`Accept: application/vnd.dardy.sso.v1+json`

Sostituire `<access_key>` e `<secret_key>` con le chiavi di accesso fornite da Dardy.

### Headers risposta HTTP

`authorization: Dardy <jwt>`

<aside class="warning">
  <code>jwt</code> è il token che deve essere utilizzato per le chiamate agli altri endpoints.
</aside>

`x-expires: <timestamp>`

<aside class="notice">
  <code>timestamp</code> indica la data di scadenza della sessione (1 giorno)
</aside>

### Codici risposta HTTP

Codice | Descrizione
-------| -------
201 | Created -- La richiesta è andata a buon fine
404 | Not Found -- Account non trovato
401 | Unauthorized -- Account non autorizzato
422 | Unprocessable Entity -- Errore di validazione
423 | Locked -- Account temporaneamente disabilitato

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

> Crea utente:

```shell
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

> Crea utente:

```shell
curl
  -X PUT
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/user/activate/<activation-code>
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

## Reinvio codice attivazione

Reinvia la mail di registrazione all'indirizzo specificato dall'utente.

> Reinvio codice attivazione:

```shell
curl
  -X POST
  -d '{"user": {
        "email": "test@example.com"
      }
    }'
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/user/activation/resend
```

> Ritorna un JSON strutturato come segue:

```json
{
  "user": {
    "status": "unverified",
    "id": 37,
    "email": "test@example.com",
    "active": false
  }
}
```

**Nota**

Per utilizzare questo endpoint è necessario creare una [sessione](#sessione).

### Richiesta HTTP

`POST https://api.dardy.me/sso/user//activation/resend`

### Headers HTTP

`Accept: application/vnd.dardy.sso.v1+json`

`Authorization: Dardy <jwt>`

<aside class="warning">
  Sostituire <code>&lt;jwt&gt;</code> con il token presente nell'header della risposta alla chiamata di sessione.
</aside>

### Codici risposta HTTP

Codice | Descrizione
------------- | -------
200 | Success -- La richiesta è andata a buon fine
404 | Not Found -- Email non trovata
422 | Unprocessable Entity -- Errore di validazione

# Autenticazione Utente

```shell
# Autenticazione utente

curl
  -X POST
  -d '{"user": {
        "email": "test@example.com",
        "password": "secret123"
      }
    }'
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/user/signin
```

> Ritorna un JSON strutturato come segue:

```json
{
  "user": {
    "status": "verified",
    "id": 37,
    "email": "test@example.com",
    "active": true
  }
}
```

### Descrizione

Autentica un utente registrato fornendo indirizzo email e password.

**Nota**

Per utilizzare questo endpoint è necessario creare una [sessione](#sessione).

### Richiesta HTTP

`POST https://api.dardy.me/user/signin`

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
404 | Not Found -- Utente non trovato
401 | Unauthorized -- Utente non autorizzato
422 | Unprocessable Entity -- Errore di validazione
423 | Locked -- Utente temporaneamente disabilitato
451 | Unavailable For Legal Reason - Utente non verificato

# Cambio Password Utente

### Descrizione

Il cambio password si completa in due fasi:

* Richiesta cambio password
* Cambio password

## Richiesta cambio password

```shell
# Richiesta cambio password

curl
  -X POST
  -d '{"user": {
        "email": "test@example.com",
        "callback_url": "https//mio.sito.com/change/password (opzionale)"
      }
    }'
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/password/reset
```

Invia una mail all'indirizzo dell'utente che ha richiesto il cambio password.

Esistono due template per la mail di richiesta cambio password:

1. Con codice cambio password (mobile)
  * Escludendo `callback_url` dal corpo del messaggio HTTP
2. Con link alla pagina di cambio password (web)
  * Includendo `callback_url` nel corpo del messaggio HTTP
  * il codice cambio password viene appeso all'url `callback_url`


**Nota**

Per utilizzare questo endpoint è necessario creare una [sessione](#sessione).

### Richiesta HTTP

`POST https://api.dardy.me/sso/password/reset`

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
404 | Not Found -- Email non trovata
422 | Unprocessable Entity -- Errore di validazione

## Cambio password

```shell
# Cambio password

curl
  -X PUT
  -d '{"user": {
        "password": "new_secret123",
        "password_confirmation": "new_secret123"
      }
    }'
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/password/reset/<reset-code>
```

Effetua il cambio password utilizzando le nuove credenziali.

**Nota**

Per utilizzare questo endpoint è necessario creare una [sessione](#sessione).

### Richiesta HTTP

`PUT https://api.dardy.me/sso/password/reset/<reset-code>`

### Parametri

Parameter | Description
--------- | -----------
&lt;reset-code&gt; | Codice di reset fornito dall'utente che ha ricevuto la mail

### Headers HTTP

`Accept: application/vnd.dardy.sso.v1+json`

`Authorization: Dardy <jwt>`

<aside class="warning">
  Sostituire <code>&lt;jwt&gt;</code> con il token presente nell'header della risposta alla chiamata di sessione.
</aside>

### Codici risposta HTTP

Codice | Descrizione
-------| -------
200 | OK -- La richiesta è andata a buon fine
404 | Not Found -- Codice non trovato
422 | Unprocessable Entity -- Errore di validazione

# Aggiornamento Profilo Utente

```shell
# Cambio password

curl
  -X PUT
  -d '{"profile": {
        "phone_number": "nuovo numero di telefono",
        "profession": "nuova professione"
      }
    }'
  -H "Accept: application/vnd.dardy.sso.v1+json"
  -H "Content-Type: application/json"
  -H "Authorization: Dardy <jwt>"
  https://api.dardy.me/sso/user/<id>/profile
```

> Ritorna un JSON strutturato come segue:

```json
{
  "user": {
    "status": "verified",
    "profile": {
      ...
      "phone_number": "nuovo numero di telefono",
      "profession": "nuova professione",
      ...
    },
    "id": 37,
    "email": "test@example.com",
    "active": true
  }
}
```

Aggiorna il profilo utente con i dati inviati nel corpo del messaggio HTTP.

**Nota**

Per utilizzare questo endpoint è necessario creare una [sessione](#sessione).

### Richiesta HTTP

`PUT https://api.dardy.me/sso/user/<id>/profile`

### Parametri

Parameter | Description
--------- | -----------
&lt;id&gt; | Id dell'utente che ha richiesto l'aggiornamento del profilo

### Headers HTTP

`Accept: application/vnd.dardy.sso.v1+json`

`Authorization: Dardy <jwt>`

<aside class="warning">
  Sostituire <code>&lt;jwt&gt;</code> con il token presente nell'header della risposta alla chiamata di sessione.
</aside>

### Codici risposta HTTP

Codice | Descrizione
-------| -------
200 | OK -- La richiesta è andata a buon fine
404 | Not Found -- Utente non trovato
422 | Unprocessable Entity -- Errore di validazione
