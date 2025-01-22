path "tbbtkv/metadata/penny/*" {
  capabilities = ["list", "create", "update", "read", "patch", "delete"]
}

path "tbbtkv/data/penny/*" {
  capabilities = ["list", "create", "update", "read", "patch", "delete"]
}

path "tbbtkv/*" {
  capabilities = ["list"]
}

path "tbbtkv/data/+/sharedsecrets/*" {
  capabilities = ["read"]
}

