terraform {
  required_version = ">= 0.13"

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.9.1"
    }
  }
}

resource "keycloak_realm" "realm" {
  depends_on = [
    kubernetes_stateful_set.keycloak
  ]

  realm = "platos"

  internationalization {
    default_locale = "pt-BR"
    supported_locales = [
      "ca",
      "cs",
      "da",
      "de",
      "en",
      "es",
      "fr",
      "hu",
      "it",
      "ja",
      "lt",
      "nl",
      "no",
      "pl",
      "pt-BR",
      "ru",
      "sk",
      "sv",
      "tr",
      "zh-CN"
    ]
  }

  reset_password_allowed = true
  remember_me            = true

  smtp_server {
    from              = var.keycloak_smtp_server_from
    from_display_name = var.keycloak_smtp_server_from_display_name
    host              = var.keycloak_smtp_server_host
    ssl               = true
    starttls          = true

    auth {
      username = var.keycloak_smtp_server_username
      password = var.keycloak_smtp_server_password
    }
  }
}

# resource "keycloak_group" "hermes_group" {
#   realm_id = keycloak_realm.realm.id
#   name     = "hermes"
# }

# resource "keycloak_group" "kafka_group" {
#   realm_id = keycloak_realm.realm.id
#   name     = "kafka"
# }

# resource "keycloak_realm" "tenant_realm" {
#   count = length(var.tenants)
#   realm = var.tenants[count.index]

#   internationalization {
#     default_locale = "pt-BR"
#     supported_locales = [
#       "ca",
#       "cs",
#       "da",
#       "de",
#       "en",
#       "es",
#       "fr",
#       "hu",
#       "it",
#       "ja",
#       "lt",
#       "nl",
#       "no",
#       "pl",
#       "pt-BR",
#       "ru",
#       "sk",
#       "sv",
#       "tr",
#       "zh-CN"
#     ]
#   }

#   login_with_email_allowed = true
#   reset_password_allowed   = true

#   smtp_server {
#     from              = var.keycloak_smtp_server_from
#     from_display_name = var.keycloak_smtp_server_from_display_name
#     host              = var.keycloak_smtp_server_host
#     ssl               = true
#     starttls          = true

#     auth {
#       username = var.keycloak_smtp_server_username
#       password = var.keycloak_smtp_server_password
#     }
#   }
# }
