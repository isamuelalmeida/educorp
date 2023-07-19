# infra-platos

Projeto responsável por provisionar a infra-estrutura utilizada pela Platos, utilizando módulos prontos da AWS para o Terraform sempre que possível. Mais informações: https://registry.terraform.io/namespaces/terraform-aws-modules

## Pré-requisitos
- AWS CLI v2 instalado
- Configurar sso com o comando `aws configure sso`
- [tfenv](https://github.com/tfutils/tfenv) instalado

## Módulos

* infrastructure/atlas: Módulo responsável por criar os clusters e configurações do MongoDB no Atlas
* infrastructure/baseline: Módulo responsável por criar a VPC, Subnets e outros recursos básicos para provisionamento de um ambiente na AWS.
* infrastructure/educorp: Módulo responsável pela infraestrutura relacionada ao projeto de Educação Corporativa.
* infrastructure/eks: Módulo responsável por criar o cluster EKS. Esse módulo utiliza o estado remoto do módulo `infrastructure/baseline` como input para obter ID da VPC, Subnets e outras informações.
* infrastructure/iam: Módulo responsável pelo provisionamento de usuários, grupos, políticas no IAM, Security Groups, etc.
* infrastructure/kubernetes: Módulo responsável por aplicações e configurações internas do cluter kubernetes.
* infrastructure/rds: Módulo responsável por provisionar bancos de dados no RDS.
* infrastructure/vpn: Módulo responsável pela configuração do Pritunl Link, responsável por se comunicar com o cluster do Pritunl e prover a funcionalidade de VPN para Platos/Ampli.

## Vantages de separar o projeto por módulos (ou sub-projetos)

Primeiro, é necessário fazer uma distinção: o termo "módulo" que está sendo utilizado nesse documento se refere a um projeto terraform auto-contido, com suas próprias configurações e estado remoto. Todos esses projetos (ou sub-projetos) compõem o todo. Não devemos confundir com o conceito de [módulos](https://www.terraform.io/language/modules/develop) do próprio terraform. Algumas vantagens de separar um projeto terraform em vários sub-projetos são: 

* Menor tempo para rodar um plano de execução (`terraform plan/apply`)
* Menor probabilidade de um desenvolvedor interferir no trabalho de outro desenvolvedor que estiver trabalhando no mesmo projeto

## Documentações

1. [Vault](./infrastructure/kubernetes/modules/vault/docs/README.md)

## Workspaces do Terraform

* dev: Ambiente de desenvolvimento, normalmente utilizado pelos times para validar features em desenvolvimento.
* stage: Ambiente de homologação, normalmente utilizado pelos times de QA e Comercial para validar features em desenvolvimento sem entrar em conflito com os times de desenvolvimento.
* production: Ambiente de produção.

## Carregando informações sensíveis no projeto

Para evitar a inclusão de informações sensíveis no repositório do projeto (senhas, API tokens, etc) as mesmas são carregadas do Parameter Store do serviço Systems Manager da AWS. Para isso foi utilizado o Data Source [aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter). Exemplo de utilização:

```
data "aws_ssm_parameter" "vault_kms_secret_access_key" {
  name = "/vault_kms_secret_access_key"
}

data "aws_ssm_parameter" "vault_cluster_keys" {
  name = "/${terraform.workspace}/vault_cluster_keys"
}
```

## Configurando SSO no AWS-CLI

- No terminal, digitar o seguinte comando: `aws configure sso`
- Na opção "sso start url", utilizar a seguinte url: https://d-906766c981.awsapps.com/start
- Na opção "role", selecionar a opção "Operator_Access" (ou "Developer_Access", caso seja desenvolvedor)
- Selecionar a conta "Platos - Educação Continuada - Cosmos - HML"
- Região: us-east-1
- Output: json
- Na opção "CLI profile name" recomendo definir um nome mais fácil de digitar no terminal. No caso do profile `Operator_Access-<account-number>`, sugiro definir apenas como `operator`
- Após completar a configuração, testar com o comando `aws s3 ls --profile operator`
- Criar a variável de ambiente `AWS_PROFILE` com o nome do profile configurado no passo anterior para poder rodar os comandos `terraform plan`, `apply`, etc:
    ```
    export AWS_PROFILE=<profile_name>
    ```
- Obs: Caso necessite configurar mais de um profile, é só executar esses passos novamente iniciando com o comando `aws configure sso`
- Obs(2): Para fazer login em um profile específico, execute o comando `aws sso login --profile <nome-do-profile>`
- Documentação oficial da AWS: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html#sso-configure-profile-auto

## Gerando um kubeconfig para utilização no [Lens](https://k8slens.dev/)

```
aws eks update-kubeconfig --region <região-do-cluster> --name <nome-do-cluster> --profile <nome-do-profile>
```

Exemplo utilizando o cluster de dev e profile configurado no passo anterior:
```
aws eks update-kubeconfig --region us-east-1 --name cosmos-eks-dev --profile operator
```