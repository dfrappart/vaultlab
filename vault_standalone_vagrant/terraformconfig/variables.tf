
variable "bebopusers" {
  type = map(object({
    username = string
    password = string

  }))
  default = {
    "user1" = {
      username = "Spike"
      password = "user1"
    }
    "user2" = {
      username = "Faye"
      password = "user2"
    }
    "user3" = {
      username = "Jet"
      password = "user3"
    }
    "user4" = {
      username = "Ed"
      password = ""
    }
    "user5" = {
      username = "Ein"
      password = ""
    }
  }
  
}