output "st2_droplet_names" {
  description = "Names of your st2 droplets."
  value       = digitalocean_droplet.st2[*].name
}

output "st2_droplet_ips" {
  description = "IPs to access your st2 droplets."
  value       = digitalocean_droplet.st2[*].ipv4_address
}
