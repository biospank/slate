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
