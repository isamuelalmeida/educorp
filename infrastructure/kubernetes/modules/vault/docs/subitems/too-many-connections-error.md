## Como atuar quando o Vault não consegue mais iniciar exibindo sempre a mensagem de erro "Error 1040: Too many connections" ?

Um dos problemas comuns encontrados na utilização do Vault na configuração atual (MySQL como storage backend gerenciado por uma instância RDS) é o esgotamento de conexões disponíveis no banco de dados após o acúmulo de "leases", que são objetos utilizados para rastrear ativamente as aplicações que utilizam o Vault como gerenciador central de segredos. A primeira alteração foi diminuir o TTL (time-to-live) do token associado à aplicação que está autenticando no Vault e consumindo algum segredo. O valor inicialmente configurado (3600 segundos) se provou muito alto, ocasionando constantemente o problema descrito no título desse artigo. Alterando o TTL para 300 segundos diminuiu consideravelmente a ocorrência desse problema mas não o eliminou totalmente.

Como identificar esse problema pelo log do Vault:

```
2021-09-29T12:19:59.713Z [INFO]  core: restoring leases
2021-09-29T12:19:59.713Z [INFO]  rollback: starting rollback manager
2021-09-29T12:19:59.781Z [INFO]  core: pre-seal teardown starting
2021-09-29T12:19:59.781Z [INFO]  rollback: stopping rollback manager
ERRO AQUI ----> 2021-09-29T12:19:59.781Z [ERROR] expiration: error restoring leases: error="failed to read lease entry auth/kubernetes/login/he7e462...: Error 1040: Too many connections"
2021-09-29T12:19:59.782Z [ERROR] core: shutting down
2021-09-29T12:19:59.782Z [INFO]  core: marked as sealed
2021-09-29T12:19:59.880Z [INFO]  core: pre-seal teardown complete
2021-09-29T12:19:59.880Z [ERROR] core: post-unseal setup failed: error="failed to read packed storage entry: Error 1040: Too many connections"
```

Comandos úteis (Vault CLI)

```
/ $ vault list /sys/leases/lookup
Keys
----
auth/

```
```
/ $ vault list /sys/leases/lookup/auth
Keys
----
kubernetes/
```
```
/ $ vault list /sys/leases/lookup/auth/kubernetes
Keys
----
login/
```
```
/ $ vault list /sys/leases/lookup/auth/kubernetes/login
Keys
----
h08fd8523b25...
h43e5e07cb32...
h45e4e0f8ad6...
h930aeb4d094...
ha5229b826ad...
ha9075de3c96...
hcfd50c5593b...
```

Caso seja impossível desbloquear o Vault, tentar por último a remoção dos leases diretamente no banco de dados (muito cuidado com essa opção!!!):
```
SELECT * FROM vault.vault v
WHERE v.vault_key like '%auth/kubernetes/login%';

DELETE FROM vault.vault 
WHERE vault_key LIKE '%auth/kubernetes/login%';
```