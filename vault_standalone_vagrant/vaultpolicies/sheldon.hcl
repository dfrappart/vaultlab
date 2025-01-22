path "tbbtkv/data/sheldon/*" {
  capabilities = ["list", "create", "update", "read", "patch", "delete"]
}

path "tbbtkv/metadata/sheldon/*" {
  capabilities = ["list", "create", "update", "read", "patch", "delete"]
}

path "tbbtkv/*" {
  capabilities = ["list"]
}

path "tbbtkv/data/+/sharedsecrets/*" {
  capabilities = ["read"]
}
