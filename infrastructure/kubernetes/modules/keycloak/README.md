### Configuração do provider

Para manipular a instalação do Keycloak via terraform é necessário criar um cliente no realm principal (master) e configurar as credenciais de acesso no provider. Mais informações podem ser encontradas na documentação do provider: https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs

### Observações

O chart do Keycloak foi atualizado para a versão 9.4.1 (no lugar da versão 3.0.4). Nessa atualização do Chart a versão do Keycloak passou da 13.x para 18.x. A maior mudança do Keycloak foi a substituição do Wildfly pelo Quarkus e a consequente alteração de algumas URL's. Utilize o seguinte endpoint para consultar os endpoints do Keycloak: https://sso.platosedu.io/realms/master/.well-known/openid-configuration