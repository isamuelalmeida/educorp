locals {
  kafka_version                 = "3.2.0"
  replicas                      = 3
  inter_broker_protocol_version = "3.2"
  log_message_format_version    = "3.2"
}

resource "kubernetes_manifest" "kafka_cluster" {
  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "Kafka"
    metadata = {
      name      = "kafka-cluster"
      namespace = "kafka"
    }
    spec = {
      entityOperator = {
        topicOperator = {
          resources = {
            requests = {
              cpu = "200m"
              memory = "512Mi"
            }
            limits = {
              cpu = "500m"
              memory = "1Gi"
            }
          }
        }

        userOperator  = {
          resources = {
            requests = {
              cpu = "100m"
              memory = "512Mi"
            }
            limits = {
              cpu = "200m"
              memory = "1Gi"
            }
          }
        }        

        template = {
          pod = {
            affinity = {
              nodeAffinity = {
                requiredDuringSchedulingIgnoredDuringExecution = {
                  nodeSelectorTerms = [
                    {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "NotIn"
                          values   = ["observability", "tools", "monolith"]
                        }
                      ]
                    }
                  ]
                }
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    weight = 1
                    preference = {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "In"
                          values   = ["microservices"]
                        }
                      ]
                    }
                  }
                ]
              }
            }
          }
        }
      }
      kafka = {
        version  = local.kafka_version
        replicas = local.replicas
        config = {
          "inter.broker.protocol.version"            = local.inter_broker_protocol_version
          "log.message.format.version"               = local.log_message_format_version
          "offsets.topic.replication.factor"         = 3
          "transaction.state.log.min.isr"            = 2
          "transaction.state.log.replication.factor" = 3
        }
        listeners = [
          {
            name = "plain"
            port = 9092
            tls  = false
            type = "internal"
          },
          {
            name = "tls"
            port = 9093
            tls  = true
            type = "internal"
          },
        ]

        resources = {
          requests = {
            cpu = "200m"
            memory = "1.5Gi"
          }
          limits = {
            cpu = "2000m"
            memory = "3Gi"
          }
        }

        storage = {
          type = "jbod"
          volumes = [
            {
              deleteClaim = false
              id          = 0
              size        = "20Gi"
              type        = "persistent-claim"
            },
            {
              deleteClaim = false
              id          = 1
              size        = "20Gi"
              type        = "persistent-claim"
            },
          ]
        }
        template = {
          podDisruptionBudget = {
            maxUnavailable = 3
          }
          pod = {
            metadata = {
              annotations = {
                "prometheus.io/port"   = "9404"
                "prometheus.io/scrape" = "true"
              }
            }

            affinity = {
              nodeAffinity = {
                requiredDuringSchedulingIgnoredDuringExecution = {
                  nodeSelectorTerms = [
                    {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "NotIn"
                          values   = ["observability", "tools", "monolith"]
                        }
                      ]
                    }
                  ]
                }
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    weight = 1
                    preference = {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "In"
                          values   = ["microservices"]
                        }
                      ]
                    }
                  }
                ]
              }
            }

          }
        }

        metricsConfig = {
          type = "jmxPrometheusExporter"
          valueFrom = {
            configMapKeyRef = {
              key  = "kafka-metrics-config.yml"
              name = "kafka-metrics-config"
            }
          }
        }
      }
      kafkaExporter = {
        groupRegex = ".*"
        topicRegex = ".*"

        template = {
          pod = {
            affinity = {
              nodeAffinity = {
                requiredDuringSchedulingIgnoredDuringExecution = {
                  nodeSelectorTerms = [
                    {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "NotIn"
                          values   = ["observability", "tools", "monolith"]
                        }
                      ]
                    }
                  ]
                }
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    weight = 1
                    preference = {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "In"
                          values   = ["microservices"]
                        }
                      ]
                    }
                  }
                ]
              }
            }
          }
        }
      }
      zookeeper = {
        replicas = 3
        resources = {
          requests = {
            cpu = "200m"
            memory = "1Gi"
          }
          limits = {
            cpu = "2000m"
            memory = "3Gi"
          }
        }
        storage = {
          deleteClaim = false
          size        = "20Gi"
          type        = "persistent-claim"
        }
        template = {
          podDisruptionBudget = {
            maxUnavailable = 3
          }
          pod = {
            metadata = {
              annotations = {
                "prometheus.io/port"   = "9404"
                "prometheus.io/scrape" = "true"
              }
            }

            affinity = {
              nodeAffinity = {
                requiredDuringSchedulingIgnoredDuringExecution = {
                  nodeSelectorTerms = [
                    {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "NotIn"
                          values   = ["observability", "tools", "monolith"]
                        }
                      ]
                    }
                  ]
                }
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    weight = 1
                    preference = {
                      matchExpressions = [
                        {
                          key      = "nodeTypeClass"
                          operator = "In"
                          values   = ["microservices"]
                        }
                      ]
                    }
                  }
                ]
              }
            }

          }
        }

        metricsConfig = {
          type = "jmxPrometheusExporter"
          valueFrom = {
            configMapKeyRef = {
              key  = "zookeeper-metrics-config.yml"
              name = "kafka-metrics-config"
            }
          }
        }

      }
    }
  }
}

resource "kubernetes_manifest" "configmap_kafka_metrics" {
  depends_on = [kubernetes_manifest.kafka_cluster]
  manifest = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "kafka-metrics-config"
      namespace = "kafka"
      labels = {
        "app" = "strimzi"
      }
    }
    data = {
      "kafka-metrics-config.yml"     = <<-EOT
      # See https://github.com/prometheus/jmx_exporter for more info about JMX Prometheus Exporter metrics
      lowercaseOutputName: true
      rules:
      # Special cases and very specific rules
      - pattern: kafka.server<type=(.+), name=(.+), clientId=(.+), topic=(.+), partition=(.*)><>Value
        name: kafka_server_$1_$2
        type: GAUGE
        labels:
          clientId: "$3"
          topic: "$4"
          partition: "$5"
      - pattern: kafka.server<type=(.+), name=(.+), clientId=(.+), brokerHost=(.+), brokerPort=(.+)><>Value
        name: kafka_server_$1_$2
        type: GAUGE
        labels:
          clientId: "$3"
          broker: "$4:$5"
      - pattern: kafka.server<type=(.+), cipher=(.+), protocol=(.+), listener=(.+), networkProcessor=(.+)><>connections
        name: kafka_server_$1_connections_tls_info
        type: GAUGE
        labels:
          listener: "$2"
          networkProcessor: "$3"
          protocol: "$4"
          cipher: "$5"
      - pattern: kafka.server<type=(.+), clientSoftwareName=(.+), clientSoftwareVersion=(.+), listener=(.+), networkProcessor=(.+)><>connections
        name: kafka_server_$1_connections_software
        type: GAUGE
        labels:
          clientSoftwareName: "$2"
          clientSoftwareVersion: "$3"
          listener: "$4"
          networkProcessor: "$5"
      - pattern: "kafka.server<type=(.+), listener=(.+), networkProcessor=(.+)><>(.+):"
        name: kafka_server_$1_$4
        type: GAUGE
        labels:
          listener: "$2"
          networkProcessor: "$3"
      - pattern: kafka.server<type=(.+), listener=(.+), networkProcessor=(.+)><>(.+)
        name: kafka_server_$1_$4
        type: GAUGE
        labels:
          listener: "$2"
          networkProcessor: "$3"
      # Some percent metrics use MeanRate attribute
      # Ex) kafka.server<type=(KafkaRequestHandlerPool), name=(RequestHandlerAvgIdlePercent)><>MeanRate
      - pattern: kafka.(\w+)<type=(.+), name=(.+)Percent\w*><>MeanRate
        name: kafka_$1_$2_$3_percent
        type: GAUGE
      # Generic gauges for percents
      - pattern: kafka.(\w+)<type=(.+), name=(.+)Percent\w*><>Value
        name: kafka_$1_$2_$3_percent
        type: GAUGE
      - pattern: kafka.(\w+)<type=(.+), name=(.+)Percent\w*, (.+)=(.+)><>Value
        name: kafka_$1_$2_$3_percent
        type: GAUGE
        labels:
          "$4": "$5"
      # Generic per-second counters with 0-2 key/value pairs
      - pattern: kafka.(\w+)<type=(.+), name=(.+)PerSec\w*, (.+)=(.+), (.+)=(.+)><>Count
        name: kafka_$1_$2_$3_total
        type: COUNTER
        labels:
          "$4": "$5"
          "$6": "$7"
      - pattern: kafka.(\w+)<type=(.+), name=(.+)PerSec\w*, (.+)=(.+)><>Count
        name: kafka_$1_$2_$3_total
        type: COUNTER
        labels:
          "$4": "$5"
      - pattern: kafka.(\w+)<type=(.+), name=(.+)PerSec\w*><>Count
        name: kafka_$1_$2_$3_total
        type: COUNTER
      # Generic gauges with 0-2 key/value pairs
      - pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Value
        name: kafka_$1_$2_$3
        type: GAUGE
        labels:
          "$4": "$5"
          "$6": "$7"
      - pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+)><>Value
        name: kafka_$1_$2_$3
        type: GAUGE
        labels:
          "$4": "$5"
      - pattern: kafka.(\w+)<type=(.+), name=(.+)><>Value
        name: kafka_$1_$2_$3
        type: GAUGE
      # Emulate Prometheus 'Summary' metrics for the exported 'Histogram's.
      # Note that these are missing the '_sum' metric!
      - pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Count
        name: kafka_$1_$2_$3_count
        type: COUNTER
        labels:
          "$4": "$5"
          "$6": "$7"
      - pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.*), (.+)=(.+)><>(\d+)thPercentile
        name: kafka_$1_$2_$3
        type: GAUGE
        labels:
          "$4": "$5"
          "$6": "$7"
          quantile: "0.$8"
      - pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+)><>Count
        name: kafka_$1_$2_$3_count
        type: COUNTER
        labels:
          "$4": "$5"
      - pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.*)><>(\d+)thPercentile
        name: kafka_$1_$2_$3
        type: GAUGE
        labels:
          "$4": "$5"
          quantile: "0.$6"
      - pattern: kafka.(\w+)<type=(.+), name=(.+)><>Count
        name: kafka_$1_$2_$3_count
        type: COUNTER
      - pattern: kafka.(\w+)<type=(.+), name=(.+)><>(\d+)thPercentile
        name: kafka_$1_$2_$3
        type: GAUGE
        labels:
          quantile: "0.$4"
      
      EOT
      "zookeeper-metrics-config.yml" = <<-EOT
      # See https://github.com/prometheus/jmx_exporter for more info about JMX Prometheus Exporter metrics
      lowercaseOutputName: true
      rules:
      # replicated Zookeeper
      - pattern: "org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\d+)><>(\\w+)"
        name: "zookeeper_$2"
        type: GAUGE
      - pattern: "org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\d+), name1=replica.(\\d+)><>(\\w+)"
        name: "zookeeper_$3"
        type: GAUGE
        labels:
          replicaId: "$2"
      - pattern: "org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\d+), name1=replica.(\\d+), name2=(\\w+)><>(Packets\\w+)"
        name: "zookeeper_$4"
        type: COUNTER
        labels:
          replicaId: "$2"
          memberType: "$3"
      - pattern: "org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\d+), name1=replica.(\\d+), name2=(\\w+)><>(\\w+)"
        name: "zookeeper_$4"
        type: GAUGE
        labels:
          replicaId: "$2"
          memberType: "$3"
      - pattern: "org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\d+), name1=replica.(\\d+), name2=(\\w+), name3=(\\w+)><>(\\w+)"
        name: "zookeeper_$4_$5"
        type: GAUGE
        labels:
          replicaId: "$2"
          memberType: "$3"

      EOT
    }
  }
}


resource "helm_release" "hermes" {
  atomic     = true
  name       = "hermes"
  chart      = "${path.module}/charts/hermes"
  namespace  = "kafka"
  depends_on = [kubernetes_manifest.kafka_cluster]

  set {
    name  = "nodeSelector.nodeTypeClass"
    value = "microservices"
  }
}

resource "helm_release" "kafdrop" {
  atomic     = true
  name       = "kafdrop"
  chart      = "${path.module}/charts/kafdrop"
  namespace  = "kafka"
  depends_on = [kubernetes_manifest.kafka_cluster]

  set {
    name  = "nodeSelector.nodeTypeClass"
    value = "microservices"
  }
}