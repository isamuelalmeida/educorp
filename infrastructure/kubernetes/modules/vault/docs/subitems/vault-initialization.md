# **Atenção**

Atualmente o Vault está configurado com a opção "auto-unseal" utilizando uma chave criptográfica gerenciada pelo serviço KMS da AWS. Os passos abaixo são referentes à uma instalação cujo processo de abertura do cofre é feito manualmente, portanto, não são mais necessários na instalação atual do Vault. Essa documentação permanece apenas como referência.

## Inicializando o cofre do Vault após fazer o deploy via terraform 

Quando um servidor do Vault é inicializado, o mesmo inicia-se com o status de "trancado" (sealed). Nenhuma operação poderá ser realizada no Vault enquanto o mesmo não for destrancado. Destrancar é o processo de construir a chave mestra para que os dados contidos no back-end de armazenamento ("storage backend") do cofre possam ser descriptografados. [Diversos](https://www.vaultproject.io/docs/configuration/storage) "storage backends" são suportados pelo Vault. Optamos por utilizar o MySQL hospedado na AWS pela facilidade de subir novas instâncias no RDS e também porque o mesmo suporta o modo de alta disponibilidade do Vault (HA).

1. O primeiro passo para destrancar o Vault é rodar o comando `vault operator init`. Observação: em ambiente de produção **não** se recomenda utilizar apenas 1 key-share para gerar a chave mestra.

```
kubectl exec vault-0 --namespace=vault -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
```

O comando acima deverá gerar o arquivo `cluster-keys.json` com o resultado do mesmo:
```
{
  "unseal_keys_b64": [
    "<chave_em_base64>"
  ],
  "unseal_keys_hex": [
    "<chave_em_hexadecima>"
  ],
  "unseal_shares": 1,
  "unseal_threshold": 1,
  "recovery_keys_b64": [],
  "recovery_keys_hex": [],
  "recovery_keys_shares": 5,
  "recovery_keys_threshold": 3,
  "root_token": "<token>"
}
```

2. Defina uma variável de ambiente contendo a chave para abrir o cofre:
```
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
```
Ou simplesmente cole a chave em base 64 diretamente:
```
VAULT_UNSEAL_KEY="chave_em_base64_aqui"
```

3. Destrave o cofre com a variável de ambiente criada no passo anterior:
```
kubectl exec vault-0 --namespace=vault -- vault operator unseal $VAULT_UNSEAL_KEY
```

Após executar esse comando o Vault deverá ser finalmente inicializado e destrancado. Rode o comando abaixo para obter o status do Vault
```
kubectl exec vault-0 --namespace=vault -- vault status
```

Se tudo ocorreu bem você deve obter um retorno parecido com isso:
```
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.7.0
Storage Type    mysql
Cluster Name    vault-cluster-xxxxxx
Cluster ID      6f80998d-7262-cb9d-dba0-de429444b735
HA Enabled      true
HA Cluster      https://<ha_cluster_address>
HA Mode         active
Active Since    2021-04-29T21:11:48.761881954Z
```

Obs: Por padrão, o projeto `infra-k8s` está configurado para fazer deploy de 2 réplicas do Vault mais o agent injector (pod responsável por fazer a injeção dos segredos nos demais pods). Portanto, ao rodar o comando `kubectl get pods -n vault` você deve obter um retorno parecido com o abaixo:
```
NAME                                    READY   STATUS    RESTARTS   AGE
vault-0                                 1/1     Running   0          4d4h
vault-1                                 1/1     Running   0          4d4h
vault-agent-injector-55d9c67dc9-llz7l   1/1     Running   0          4d4h
```

## Criando um segredo de teste e habilitando autenticação no Vault via Kubernetes para que as aplicações possam consultar os segredos

1. Como vimos nos passos anteriores, o Vault está configurado em modo de alta disponibilidade, o que faz com que um pod do servidor do Vault esteja com o status de ativo e os demais com o status de "standby". Pudemos verificar no passo anterior que o pod `vault-0` estava com o status de `active`. Vamos verificar o status do pod `vault-1` para confirmar que o mesmo se encontra em `standy`:
```
kubectl exec vault-1 --namespace=vault -- vault status
```
Que retornará um resultado próximo do abaixo:
```
Key                    Value
---                    -----
Seal Type              shamir
Initialized            true
Sealed                 false
Total Shares           1
Threshold              1
Version                1.7.0
Storage Type           mysql
Cluster Name           vault-cluster-xxxxxx
Cluster ID             6f80998d-7262-cb9d-dba0-de429444b735
HA Enabled             true
HA Cluster             https://<ha_cluster_address>
HA Mode                standby
Active Node Address    http://<node_address>
```

2. Com tudo configurado corretamente, vamos abrir um shell para o pod `vault-0` para executar os próximos comandos:
```
kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh
```

3. O primeiro passo é fazer login no Vault via linha de comando:
```
vault login
```
Utilize o root token gerado no passos anteriores quando destrancamos o Vault.

4. Agora vamos habilitar o mecanismo de segredos (secrets engine) do tipo chave-valor na versão v2 (kv-v2). Para mais informações sobre os secrets engines disponíveis, você pode consultar a [documentação](https://www.vaultproject.io/docs/secrets) oficial do Vault.
```
vault secrets enable -path=secrets kv-v2
```
Obs: O caminho definido na flag `-path=secrets` pode ser outro de sua preferência.

5. Para esse exemplo vamos criar um segredo de teste no caminho recém criado:
```
vault kv put secrets/playground/config username="my-user" password="my-password"
```

6. O próximo passo é habilitar a autenticação via kubernetes, que será o método utilizado para as aplicações poderem se autenticar ao Vault.
```
vault auth enable kubernetes
```

7. O próximo passo é configurar o mecanismo de autenticação do kubernetes para utilizar um "service account token" (toda aplicação que for utilizar o Vault deve ter um "service account" configurado com o nome da aplicação):
```
vault write auth/kubernetes/config \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

8. Com o secret criado e a autenticação do kubernetes configurada, o próximo passo é controlar quem pode acessar e modificar o conteúdo do secret. Para isso nós vamos criar uma política com permissão de leitura ("read") para o secret criado anteriormente:
```
vault policy write playground - <<EOF
path "secrets/data/playground/config" {
  capabilities = ["read"]
}
EOF
```

Obs: Para que um cliente acesse um segredo configurado no caminho "secrets/playground/config" é necessário criar uma política de acesso no caminho "secrets/data/playground/config".

9. Para que essa política recém criada seja aplicada, é necessário criar um "role" que conecte o "service account" da aplicação (que deverá ser configurado dentro da pasta "helm" de cada aplicação) com a política.
```
vault write auth/kubernetes/role/playground \
        bound_service_account_names=playground \
        bound_service_account_namespaces=playground \
        policies=playground \
        ttl=24h
```

10. Por fim, feche a conexão com o pod:
```
exit
```

11. Não deixe de consultar a aplicação "[playground](https://gitlab.com/platosedu/cosmos/playground)" no gitlab para mais informações de como consumir os secrets do Vault na aplicação.


## Integrando o Vault com o Keycloak manualmente

Um dos benefícios de integrar o Keycloak com o Vault é a centralização de usuários, evitando a necessidade de gerenciar acesso internamente no Vault. 

1. O primeiro passo é criar um cliente para o Vault dentro do Keycloak. Para isso, acesse o console de administração do Keycloak, selecione o Realm desejado (no nosso caso será o Realm Cosmos) e navegue até a opção "Clients". 

2. Clique no botão "Create" e preencha o campo "Client ID" com o nome "vault". Na opção "Client Protocol" selecione "openid-connect" e clique em "Save".

3. Encontre o cliente recém criado na lista, clique na opção "Edit" e preencha a aba "Settings" com as seguintes informações (no exemplo foi utilizado a configuração do ambiente de stage):

![Keycloak Vault Client](./images/keycloak_vault_client.png)

4. Após salvar as configurações, navegue até a opção "Roles" e crie dois novos roles com o nome de "user" e "management". Esses roles serão utilizados para mapear as permissões do usuário no keycloak com as políticas de acesso do Vault. Essas políticas de acesso controlam as permissões que o usuário possui dentro do Vault para visualizar, criar, editar e remover segredos.

5. O próximo passo é criar um "mapper" para instruir como o Vault obterá as permissões que o usuário gerenciado pelo Keycloak possui em relação a ele. Essas informações estão presentes no JWT gerado pelo Keycloak após o usuário ser autenticado com sucesso. Para criar o "mapper" navegue até "Clients" -> Encontre o cliente do Vault e clique em "Edit" -> "Mappers" -> "Create". No campo "Name" insira "user-client-role-mapper" e no campo "Mapper Type" selecione a opção "User Client Role". No campo "Client ID" selecione o cliente "vault" e marque as seguintes opções:

```
Multivalued: ON
Token Claim Name: resource_acces.vault.roles
Claim JSON Type: String
Add to ID token: ON
Add to access token: ON
Add to useringo: ON
```

6. Observação: Caso você já possua um usuário criado Keycloak, você pode testar o login enviando uma requisição HTTP POST para o endereço `https://sso.platosedu.io/auth/realms/<nome_do_realm>/protocol/openid-connect/token`. No corpo da requisição você deve utilizar um `Form URL Encoded` com as seguintes informações:

```
username: <seu_usuario>
password: <sua_senha>
grant_type: password
client_id: <id_do_cliente> (no caso do Vault utilize "vault", sem aspas)
client_secret: <client_secret_configurado_no_keycloak>
```
Se tudo ocorrer bem você deverá obter uma resposta com código 200 contendo um corpo semelhante ao conteúdo abaixo:

```
{
  "access_token": "eyJhbG....",
  "expires_in": 300,
  "refresh_expires_in": 1800,
  "refresh_token": "eyJhbGc....",
  "token_type": "Bearer",
  "not-before-policy": 0,
  "session_state": "aee88419-e69a-40cb-b369-974806bee99d",
  "scope": "profile email"
}
```

Dica: Utiliza o site `https://jwt.io/` para inspecionar o conteúdo do "access_token" e "refresh_token" retornado.

7. Agora é necessário criar uma política de acesso no Vault para mapear as permissões do usuário do Keycloak conforme descrito no passo 4. A criação de uma política de acesso via linha de comando já foi descrita no passo 8 da seção `Criando um segredo de teste e habilitando...`. Também é possível criar uma política de acesso no Vault pela interface web, bastanto acessar o endereço de [stage](https://vault.stage.platosedu.io) ou [produção](https://vault.platosedu.io). Após fazer login no Vault utilizando o **root token**, navegue até **Policies** no menu principal e clique em **Create ACL Policy**. Crie uma política chamada **user** com o seguinte conteúdo (o conteúdo da política é escrito em HCL - Hashicorp Configuration Language):

```
path "secrets/*" {
    capabilities = ["list"]
}

path "secrets/data/*" {
  capabilities = ["read"]
}
```

Essa configuração permite que todos os usuários com a permissão de **user** listem os segredos contidos no caminho `secrets` bem como visualizem o seu conteúdo.