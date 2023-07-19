# Contexto: O plugin "kong_request_transformer_plugin_tenant_resolver" é utilizado para resolver o subdomínio do host
# (exemplo: kroton.platosedu.io, umc.platosedu.io) e adicioná-lo no header do request com o nome "tenantId: <subdomínio>".
# Por algum motivo, ao configurar o manifesto do kubernetes utilizando código terraform, o script lua contido na definição do plugin
# acabava jogando lixo na string retornada. Exemplo: Para o host "kroton.platosedu.io" o script retornava kroton%0A, onde normalmente "%0A" representa o
# caractere de quebra de linha (\r). A única forma encontrada de não incluir esse lixo na string foi carregar o manifesto
# diretamente via função "yamldecode()".
resource "kubernetes_manifest" "kong_request_transformer_plugin_tenant_resolver" {
  depends_on = [helm_release.kong_gateway]

  manifest = yamldecode(file("${path.module}/plugins/request-transformer-plugin-tenant-resolver.yaml"))
}

resource "kubernetes_manifest" "kong_request_transformer_plugin_cosmos_login" {
  depends_on = [helm_release.kong_gateway]

  manifest = {
    apiVersion = "configuration.konghq.com/v1"
    kind       = "KongPlugin"
    metadata = {
      name      = "request-transformer-cosmos-login"
      namespace = "cosmos"
    }
    config = {
      replace = {
        uri = "/lms/api/login"
      }
    }
    plugin = "request-transformer"
  }
}