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
