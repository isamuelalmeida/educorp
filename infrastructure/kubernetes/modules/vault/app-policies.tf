# vault secrets enable -path=secrets kv-v2
resource "vault_mount" "kv_v2" {
  path        = "secrets"
  type        = "kv-v2"
  description = "Engine de secrets utilizado pelas aplicações"
}


resource "vault_policy" "playground" {
  name   = "playground"
  policy = <<EOT
    path "secrets/data/playground/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "playground_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "playground"
  bound_service_account_names      = ["playground"]
  bound_service_account_namespaces = ["playground"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["playground"]
}

resource "vault_policy" "cosmos" {
  name   = "cosmos"
  policy = <<EOT
    path "secrets/data/cosmos/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "cosmos_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "cosmos"
  bound_service_account_names      = ["cosmos-erp", "cosmos-lms", "cosmos-rest"]
  bound_service_account_namespaces = ["cosmos"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["cosmos"]
}

resource "vault_policy" "backstage" {
  name   = "backstage"
  policy = <<EOT
    path "secrets/data/backstage/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "backstage_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "backstage"
  bound_service_account_names      = ["backstage"]
  bound_service_account_namespaces = ["backstage"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["backstage"]
}

resource "vault_policy" "user" {
  name   = "user"
  policy = <<EOT
    path "secrets/*" {
        capabilities = ["list"]
    }

    path "secrets/data/*" {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = <<EOT
    path "sys/leases/*" {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }

    path "sys/leases/lookup" {
      capabilities = ["list", "sudo"]
    }

    path "secrets/*" {
      capabilities = ["list"]
    }

    path "secrets/data/*" {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }
  EOT
}

resource "vault_policy" "service_indica" {
  name   = "service-indica"
  policy = <<EOT
    path "secrets/data/service-indica/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_indica_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-indica"
  bound_service_account_names      = ["service-indica"]
  bound_service_account_namespaces = ["service-indica"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-indica"]
}

resource "vault_policy" "service_docs" {
  name   = "service-docs"
  policy = <<EOT
    path "secrets/data/service-docs/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_docs_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-docs"
  bound_service_account_names      = ["service-docs"]
  bound_service_account_namespaces = ["service-docs"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-docs"]
}

resource "vault_policy" "service_product" {
  name   = "service-product"
  policy = <<EOT
    path "secrets/data/service-product/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_product_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-product"
  bound_service_account_names      = ["service-product"]
  bound_service_account_namespaces = ["service-product"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-product"]
}

resource "vault_policy" "service_digitalfinance" {
  name   = "service-digitalfinance"
  policy = <<EOT
    path "secrets/data/service-digitalfinance/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_digitalfinance_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-digitalfinance"
  bound_service_account_names      = ["service-digitalfinance"]
  bound_service_account_namespaces = ["service-digitalfinance"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-digitalfinance"]
}

resource "vault_policy" "service_pricing" {
  name   = "service-pricing"
  policy = <<EOT
    path "secrets/data/service-pricing/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_pricing_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-pricing"
  bound_service_account_names      = ["service-pricing"]
  bound_service_account_namespaces = ["service-pricing"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-pricing"]
}

resource "vault_policy" "api_indica" {
  name   = "api-indica"
  policy = <<EOT
    path "secrets/data/api-indica/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "api_indica_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "api-indica"
  bound_service_account_names      = ["api-indica"]
  bound_service_account_namespaces = ["api-indica"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["api-indica"]
}

resource "vault_policy" "service_promotion" {
  name   = "service-promotion"
  policy = <<EOT
    path "secrets/data/service-promotion/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_promotion_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-promotion"
  bound_service_account_names      = ["service-promotion"]
  bound_service_account_namespaces = ["service-promotion"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-promotion"]
}

resource "vault_policy" "service_debtnegotiation" {
  name   = "service-debtnegotiation"
  policy = <<EOT
    path "secrets/data/service-debtnegotiation/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_debtnegotiation_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-debtnegotiation"
  bound_service_account_names      = ["service-debtnegotiation"]
  bound_service_account_namespaces = ["service-debtnegotiation"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-debtnegotiation"]
}

resource "vault_policy" "gitlab" {
  name   = "gitlab"
  policy = <<EOT
    path "secrets/data/infra-cdc/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_jwt_auth_backend_role" "gitlab_role" {
  backend        = vault_jwt_auth_backend.gitlab_jwt_auth_backend.path
  role_name      = "gitlab"
  role_type      = "jwt"
  token_ttl      = 300 # 5min
  token_policies = ["gitlab"]

  user_claim   = "project_id"
  groups_claim = "project_id"
  bound_claims = {
    iss = "gitlab.com"
  }
  claim_mappings = {
    namespace_id   = "namespace_id"
    namespace_path = "namespace_path"
    project_id     = "project_id"
    project_path   = "project_path"
  }
}


resource "vault_policy" "service_order" {
  name   = "service-order"
  policy = <<EOT
    path "secrets/data/service-order/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_order_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-order"
  bound_service_account_names      = ["service-order"]
  bound_service_account_namespaces = ["service-order"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-order"]
}

resource "vault_policy" "service_payment" {
  name   = "service-payment"
  policy = <<EOT
    path "secrets/data/service-payment/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_payment_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-payment"
  bound_service_account_names      = ["service-payment"]
  bound_service_account_namespaces = ["service-payment"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-payment"]
}

resource "vault_policy" "service_cms" {
  name   = "service-cms"
  policy = <<EOT
    path "secrets/data/service-cms/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_cms_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-cms"
  bound_service_account_names      = ["service-cms"]
  bound_service_account_namespaces = ["service-cms"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-cms"]
}

resource "vault_policy" "service_goodsales" {
  name   = "service-goodsales"
  policy = <<EOT
    path "secrets/data/service-goodsales/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_goodsales_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-goodsales"
  bound_service_account_names      = ["service-goodsales"]
  bound_service_account_namespaces = ["service-goodsales"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-goodsales"]
}

resource "vault_policy" "service_cart" {
  name   = "service-cart"
  policy = <<EOT
    path "secrets/data/service-cart/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_cart_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-cart"
  bound_service_account_names      = ["service-cart"]
  bound_service_account_namespaces = ["service-cart"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-cart"]
}

resource "vault_policy" "service_bankslip" {
  name   = "service-bankslip"
  policy = <<EOT
    path "secrets/data/service-bankslip/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_bankslip_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-bankslip"
  bound_service_account_names      = ["service-bankslip"]
  bound_service_account_namespaces = ["service-bankslip"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-bankslip"]
}

resource "vault_policy" "service_catalog" {
  name   = "service-catalog"
  policy = <<EOT
    path "secrets/data/service-catalog/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_catalog_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-catalog"
  bound_service_account_names      = ["service-catalog"]
  bound_service_account_namespaces = ["service-catalog"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-catalog"]
}

resource "vault_policy" "service_crm" {
  name   = "service-crm"
  policy = <<EOT
    path "secrets/data/service-crm/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_crm_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-crm"
  bound_service_account_names      = ["service-crm"]
  bound_service_account_namespaces = ["service-crm"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-crm"]
}

resource "vault_policy" "python_marketing_dash" {
  name   = "python-marketing-dash"
  policy = <<EOT
    path "secrets/data/python-marketing-dash/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "python_marketing_dash_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "python-marketing-dash"
  bound_service_account_names      = ["python-marketing-dash"]
  bound_service_account_namespaces = ["python-marketing-dash"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["python-marketing-dash"]
}

resource "vault_policy" "service_raid" {
  name   = "service-raid"
  policy = <<EOT
    path "secrets/data/service-raid/config" {
      capabilities = ["read"]
    }
  EOT
}



resource "vault_kubernetes_auth_backend_role" "service_raid_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-raid"
  bound_service_account_names      = ["service-raid"]
  bound_service_account_namespaces = ["service-raid"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-raid"]
}

resource "vault_policy" "service_auth" {
  name   = "service-auth"
  policy = <<EOT
    path "secrets/data/service-auth/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_auth_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-auth"
  bound_service_account_names      = ["service-auth"]
  bound_service_account_namespaces = ["service-auth"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-auth"]
}

resource "vault_policy" "service_opm_externo" {
  name   = "service-opm-externo"
  policy = <<EOT
    path "secrets/data/service-opm-externo/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_opm_externo_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-opm-externo"
  bound_service_account_names      = ["service-opm-externo"]
  bound_service_account_namespaces = ["service-opm-externo"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-opm-externo"]
}

resource "vault_policy" "educorp_callink" {
  name   = "educorp-callink"
  policy = <<EOT
    path "secrets/data/educorp-callink/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "educorp_callink_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "educorp-callink"
  bound_service_account_names      = ["educorp-callink"]
  bound_service_account_namespaces = ["educorp-callink"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["educorp-callink"]
}

resource "vault_policy" "alexandria_service" {
  name   = "alexandria-service"
  policy = <<EOT
    path "secrets/data/alexandria-service/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_alexandria_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "alexandria-service"
  bound_service_account_names      = ["alexandria-service"]
  bound_service_account_namespaces = ["kroton"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["alexandria-service"]
}

resource "vault_policy" "sag_service" {
  name   = "sag-service"
  policy = <<EOT
    path "secrets/data/sag-service/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_sag_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "sag-service"
  bound_service_account_names      = ["sag-service"]
  bound_service_account_namespaces = ["kroton"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["sag-service"]
}

resource "vault_policy" "service_enrollment" {
  name   = "service-enrollment"
  policy = <<EOT
    path "secrets/data/service-enrollment/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_enrollment_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-enrollment"
  bound_service_account_names      = ["service-enrollment"]
  bound_service_account_namespaces = ["service-enrollment"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-enrollment"]
}

resource "vault_policy" "service_openai" {
  name   = "service-openai"
  policy = <<EOT
    path "secrets/data/service-openai/config" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "service_openai_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "service-openai"
  bound_service_account_names      = ["service-openai"]
  bound_service_account_namespaces = ["service-openai"]
  token_ttl                        = 300 # 5min
  token_policies                   = ["service-openai"]
}