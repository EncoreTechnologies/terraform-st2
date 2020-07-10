resource "digitalocean_project" "stackstorm_terraformed" {
  name = var.do_project_name
  description = "Terraformed stackstorm demo deployments."
  purpose = "Operational / Developer tooling"
  environment = "Development"
  resources = concat(
    digitalocean_droplet.st2[*].urn,
  )
}
