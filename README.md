# hello-identity-aware-proxy
This repo is home to an example usage of Google's [Identity-Aware-Proxy](https://cloud.google.com/iap).

## Prereqs

Setup [Terraform with Google Cloud](https://cloud.google.com/docs/terraform)

## Steps

1.  Copy `example.tfvars` to `your-name.tfvars` & update it according your project/region etc.
1.  Create resources via
    ```bash
    terraform apply -var-file=your-name.tfvars
    ```
1.  (Optional) Navigate to [VM instance in GCP Console](https://console.cloud.google.com/compute/instances?instancesquery=%255B%257B_22k_22_3A_22name_22_2C_22t_22_3A10_2C_22v_22_3A_22_5C_22iap-test_5C_22_22%257D%255D) and note that the `iap-test` instance sits in a private VPC and doesn't have an external IP.
1.  Despite the lack of public IP, ssh into the machine via:
    ```bash
    gcloud compute ssh iap-test
    ```
    Note: This assumes gcloud is already configured to your project & you are logged in to the member specified in `your-name.tfvars`
1.  Finally, destroy resources with:
    ```
    terraform destroy -var-file=your-name.tfvars 
    ```