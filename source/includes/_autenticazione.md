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
