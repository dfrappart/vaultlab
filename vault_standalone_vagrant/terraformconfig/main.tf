

resource "vault_mount" "kvv2" {
  path = "kvstores/bebopkv"
  type = "kv-v2"
  options = {
    version = "2"
    type    = "kv-v2"
  }
  description = "This is an KV Version 2 secret engine mount created by terraform"
}

resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  path        = "yetanotheruserpath"
  description = "This is an example userpass auth backend created by terraform"

  tune {
    max_lease_ttl      = "90000s"
    listing_visibility = "unauth"
  }
}

resource "vault_policy" "accessbebopkv" {
  for_each = var.bebopusers
  name = "${each.value.username}policy"

  policy = templatefile("${path.root}/policies/bebopkvtemplate.hcl", {
    Kvv2StoreName    = vault_mount.kvv2.path
    UserPassUserName = each.value.username
  })
}