path "tbbtkv/data/david/*" {
  capabilities = ["list", "create", "update", "read", "patch", "delete"]
}

path "tbbtkv/metadata/david/*" {
  capabilities = ["list", "create", "update", "read", "patch", "delete"]
}

path "tbbtkv/*" {
  capabilities = ["list"]
}

path "tbbtkv/data/+/sharedsecrets/*" {
  capabilities = ["read"]
}

