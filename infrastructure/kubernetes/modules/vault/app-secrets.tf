resource "vault_kv_secret_v2" "cosmos" {
  mount = vault_mount.kv_v2.path
  name  = "cosmos/config"
  data_json = jsonencode(
    {
      APP_NAME = "cosmos"
    }
  )
}

resource "vault_kv_secret_v2" "playground" {
  mount = vault_mount.kv_v2.path
  name  = "playground/config"
  data_json = jsonencode(
    {
      APP_NAME = "playground"
    }
  )
}

resource "vault_kv_secret_v2" "service-bankslip" {
  mount = vault_mount.kv_v2.path
  name  = "service-bankslip/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-bankslip"
    }
  )
}

resource "vault_kv_secret_v2" "service-cart" {
  mount = vault_mount.kv_v2.path
  name  = "service-cart/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-cart"
    }
  )
}

resource "vault_kv_secret_v2" "service-catalog" {
  mount = vault_mount.kv_v2.path
  name  = "service-catalog/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-catalog"
    }
  )
}

resource "vault_kv_secret_v2" "service-cms" {
  mount = vault_mount.kv_v2.path
  name  = "service-cms/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-cms"
    }
  )
}

resource "vault_kv_secret_v2" "service-docs" {
  mount = vault_mount.kv_v2.path
  name  = "service-docs/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-docs"
    }
  )
}

resource "vault_kv_secret_v2" "service-goodsales" {
  mount = vault_mount.kv_v2.path
  name  = "service-goodsales/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-goodsales"
    }
  )
}

resource "vault_kv_secret_v2" "service-indica" {
  mount = vault_mount.kv_v2.path
  name  = "service-indica/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-indica"
    }
  )
}

resource "vault_kv_secret_v2" "service-order" {
  mount = vault_mount.kv_v2.path
  name  = "service-order/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-order"
    }
  )
}

resource "vault_kv_secret_v2" "service-payment" {
  mount = vault_mount.kv_v2.path
  name  = "service-payment/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-payment"
    }
  )
}

resource "vault_kv_secret_v2" "service-pricing" {
  mount = vault_mount.kv_v2.path
  name  = "service-pricing/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-pricing"
    }
  )
}

resource "vault_kv_secret_v2" "service-product" {
  mount = vault_mount.kv_v2.path
  name  = "service-product/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-product"
    }
  )
}

resource "vault_kv_secret_v2" "service-promotion" {
  mount = vault_mount.kv_v2.path
  name  = "service-promotion/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-promotion"
    }
  )
}

resource "vault_kv_secret_v2" "service-raid" {
  mount = vault_mount.kv_v2.path
  name  = "service-raid/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-raid"
    }
  )
}

resource "vault_kv_secret_v2" "service-auth" {
  mount = vault_mount.kv_v2.path
  name  = "service-auth/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-auth"
    }
  )
}

resource "vault_kv_secret_v2" "service-opm-externo" {
  mount = vault_mount.kv_v2.path
  name  = "service-opm-externo/config"
  data_json = jsonencode(
    {
      APP_NAME = "service-opm-externo"
    }
  )
}