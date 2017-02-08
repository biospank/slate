---
title: Documentazione API SSO

language_tabs:
  - shell
  - ruby
  - javascript

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduzione

SSO è un sistema di autenticazione centralizzato per web e mobile.
Espone servizi (endpoints) in modalità REST per la registrazione, autenticazione e notifica via mail degli utenti appartenenti ad unità organizzative che intendono aderire al sistema di autenticazione centralizzato.

Le funzionalità esposte sono:

* Sessione account
* Registrazione utente
* Autenticazione utente
* Aggiornamento profilo utente
* Cambio password

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

> Ritorna i seguenti headers http:

```http
authorization: Dardy <jwt>
x-expires: <timestamp>
```

> [jwt](https://en.wikipedia.org/wiki/JSON_Web_Token) è il token che deve essere utilizzato per le chiamate agli altri endpoints.

> [timestamp](https://en.wikipedia.org/wiki/Unix_timevoid()) indica la data di scadenza della sessione (1 giorno)

### Descrizione

SSO usa chiavi di accesso per l'utilizzo dele API. Per richiedere le chiavi di accesso contattare il provider Dardy.

### Richiesta HTTP

`POST https://api.dardy.me/sso/session`

La creazione della sessione richiede l'inclusione del seguente header http:

`Accept: application/vnd.dardy.sso.v1+json`

Sostituire `<access_key>` e `<secret_key>` con le chiavi di accesso fornite da Dardy.

# Registrazione

### Descrizione

Crea un utente inviando una mail all'indirizzo specificato dall'utente per la procedura di registrazione e una notifica via mail all'indirizzo dell'account.

## Creazione utente

### Descrizione

Crea un utente `non attivo` in stato `non verificato`.

> Crea utente:

```shell
curl
  -X POST
  -d '{"user": {
        "email": "test@example.com",
        "password": "secret123",
        "password_confirmation": "secret123",
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

> Sostituire `<jwt>` con il token presente dell'header della risposta alla chiamata [sessione](#sessione)

> ritorna un JSON strutturato come segue:

```json
{
  "user": {
    "id": 37,
    "status": "unverified",
    "email": "test@example.com",
    "active": false
  }
}
```

La registrazione utente richiede l'inclusione dei seguenti headers http:

`Accept: application/vnd.dardy.sso.v1+json`

`Authorization: Dardy <jwt>`

**Nota**

Per utilizzare questo endpoint è necessario creare una sessione.

### Richiesta HTTP

`POST https://api.dardy.me/sso/user/signup`

### Codici errore

Codice | Descrizione
------------- | -------
201 | Created -- La richiesta è andata a buon fine
404 | Not Found -- Codice di attivazione non valido

<aside class="notice">
Sostituire <code>&lt;jwt&gt;</code> con il token presente dell'header della risposta alla chiamata [sessione](#sessione).
</aside>

## Attivazione utente

### Descrizione

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

> Sostituire `<jwt>` con il token presente dell'header della risposta alla chiamata [sessione](#sessione)

> Sostituire `<activation-code>` con il codice di attivazione fornito dall'utente che ha ricevuto la mail

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

La registrazione utente richiede l'inclusione dei seguenti headers http:

`Accept: application/vnd.dardy.sso.v1+json`

`Authorization: Dardy <jwt>`

**Nota**

Per utilizzare questo endpoint è necessario creare una sessione.

### Richiesta HTTP

`POST https://api.dardy.me/sso/user/activate/<activation-code>`

### Parametri

Parameter | Description
--------- | -----------
activation-code | Codice di attivazione fornito dall'utente che ha ricevuto la mail

### Codici errore

Codice | Descrizione
------------- | -------
200 | Success -- La richiesta è andata a buon fine
404 | Not Found -- Codice di attivazione non valido
