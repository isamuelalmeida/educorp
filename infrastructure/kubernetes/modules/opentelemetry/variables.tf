variable "namespace_instrumentation" {
  type = map(object({
    namespace = string
    sampler  = string
  }))
  default = {
    spring_demo = {
      namespace = "spring-demo"
      sampler  = "1"
    }
    cosmos = {
      namespace = "cosmos"
      sampler  = "0.1"
    }
    service_bankslip = {
      namespace = "service-bankslip"
      sampler  = "1"
    }
    service_catalog = {
      namespace = "service-catalog"
      sampler  = "1"
    }
    service_cms = {
      namespace = "service-cms"
      sampler  = "1"
    }
    service_crm = {
      namespace = "service-crm"
      sampler  = "1"
    }
    service_debtnegotiation = {
      namespace = "service-debtnegotiation"
      sampler  = "1"
    }
    service_digitalfinance = {
      namespace = "service-digitalfinance"
      sampler  = "1"
    }
    service_docs = {
      namespace = "service-docs"
      sampler  = "1"
    }
    service_enrollment = {
      namespace = "service-enrollment"
      sampler  = "1"
    }
    service_goodsales = {
      namespace = "service-goodsales"
      sampler  = "1"
    }
    service_indica = {
      namespace = "service-indica"
      sampler  = "1"
    }
    service_lead = {
      namespace = "service-lead"
      sampler  = "1"
    }
    service_openai = {
      namespace = "service-openai"
      sampler  = "1"
    }
    service_opm_externo = {
      namespace = "service-opm-externo"
      sampler  = "1"
    }
    service_order = {
      namespace = "service-order"
      sampler  = "1"
    }
    service_payment = {
      namespace = "service-payment"
      sampler  = "1"
    }
    service_pricing = {
      namespace = "service-pricing"
      sampler  = "1"
    }
    service_product = {
      namespace = "service-product"
      sampler  = "1"
    }
    service_progress = {
      namespace = "service-progress"
      sampler  = "1"
    }
    service_promotion = {
      namespace = "service-promotion"
      sampler  = "1"
    }
    service_raid = {
      namespace = "service-raid"
      sampler  = "1"
    }
    front_catalog = {
      namespace = "front-catalog"
      sampler  = "1"
    }
  }
}