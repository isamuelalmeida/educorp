resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

# Observação: Em caso de erro de autenticação do pod "vault-agent-init", abrir um shell do pod do vault (vault-0, vault-1, etc), fazer login 
# utilizando o root token e rodar o comando abaixo:
#
# vault write auth/kubernetes/config \
#         token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
#         kubernetes_host="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT" \
#         kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
resource "vault_kubernetes_auth_backend_config" "kubernetes_config" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = "https://172.20.0.1:443" #TODO: Configurar essa propriedade com o API Server Endpoint aparentemente não funciona
  kubernetes_ca_cert = var.kubernetes_ca_cert
  # A configuração abaixo (disable_iss_validation = true) é necessária após atualização do cluster k8s para 1.21.x. 
  # Mais informações em:
  #   https://github.com/external-secrets/kubernetes-external-secrets/issues/721
  #   https://github.com/hashicorp/vault/issues/11953
  #   https://github.com/hashicorp/vault-helm/issues/562
  disable_iss_validation = true
}
