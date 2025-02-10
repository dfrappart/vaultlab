
provider "vault" {
  address = "http://192.168.56.11:8200"

  #auth_login_userpass {
  #  username = "terraform"
  #  password_file = "./terraformvaultpwd.txt"
  #}

  auth_login {
    path = "auth/userpass/login/terraform"
    parameters = {
      username = "terraform"
      password = file("./terraformvaultpwd.txt")
    }
  }

}