## TODO

- Corrigir erro na instalação do cluster kafka:
```
│ Error: Failed to determine GroupVersionResource for manifest
│ 
│   with module.kafka_cluster.kubernetes_manifest.kafka_cluster,
│   on modules/kafka_cluster/main.tf line 10, in resource "kubernetes_manifest" "kafka_cluster":
│   10: resource "kubernetes_manifest" "kafka_cluster" {
│ 
│ no matches for kind "Kafka" in group "kafka.strimzi.io"
```
Como instalar o cluster hoje: comentar o código do módulo **kafka_cluster**, instalar o módulo **kafka_strimzi_operator** primeiro (o que inclui os Custom Resource Definitions do Strimzi Operator) e por último realizar a instalação do cluster kafka.