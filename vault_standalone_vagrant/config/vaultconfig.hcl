storage "raft" {
  path    = "/opt/vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "http://0.0.0.0:8200"
cluster_addr = "https://serverip:8201"
ui = true

#seal "azurekeyvault" {
#  tenant_id      = ""
#  client_id      = ""
#  client_secret  = ""
#  vault_name     = ""
#  key_name       = ""
#}

