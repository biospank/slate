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
  <code>&lt;jwt&gt;</code> è il token che deve essere utilizzato per le chiamate agli altri endpoints.
</aside>

`x-expires: <timestamp>`

<aside class="notice">
  <code>&lt;timestamp&gt;</code> indica la data di scadenza della sessione (1 giorno)
</aside>

### Codici risposta HTTP

Codice | Descrizione
-------| -------
201 | Created -- La richiesta è andata a buon fine
404 | Not Found -- Account non trovato
401 | Unauthorized -- Account non autorizzato
422 | Unprocessable Entity -- Errore di validazione
423 | Locked -- Account temporaneamente disabilitato
