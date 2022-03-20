output "my-app-server-public-ip" {
  value = module.my-app-webserver.ec2-public_ip
}
