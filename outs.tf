output "tunnel_command" {
  value = <<EOF
  gcloud compute start-iap-tunnel iap-test 8080 \
    --local-host-port=localhost:8080
  EOF
}

output "ssh_command" {
  value = <<EOF
  gcloud compute ssh iap-test
  EOF
}
