# Terraform for Confluence Cloud Federated Search Connector for Gemini Enterprise 

This Terraform module provisions a **Google Discovery Engine Data Connector** configured for **Confluence Cloud Federated Search** in Gemini Enterprise.

In **Federated Search mode**, Gemini Enterprise sends search queries directly to Atlassian's Confluence Cloud API in real-time, retrieving live results without needing data ingestion or indexing schedules.

---

## Prerequisites

1. **GCP IAM Permissions**:
   - `roles/discoveryengine.editor` to create data connectors and collections.
   - `roles/secretmanager.admin` or `roles/secretmanager.secretAccessor` to manage OAuth secret keys.

2. **Atlassian Developer Console Setup (OAuth 2.0)**:
   - Go to the [Atlassian Developer Console](https://developer.atlassian.com/console/myapps/).
   - Create a **3LO (Three-Legged OAuth 2.0)** App for Confluence Cloud.
   - Add the necessary Confluence Cloud scopes (`read:confluence-space.summary`, `read:confluence-content.all`, `search:confluence`).
   - Note down the **Client ID** and **Client Secret**.
   - Obtain your Atlassian Cloud Instance ID (`cloudId`) by visiting `https://YOUR-DOMAIN.atlassian.net/_edge/tenant_info`.

---

## Module Files

- [`main.tf`](main.tf): Provider setup, Secret Manager resources for OAuth secrets, and `google_discovery_engine_data_connector` configured with `connector_modes = ["FEDERATED"]`.
- [`variables.tf`](variables.tf): Variable declarations for GCP project ID, location, Confluence instance URI, cloudId, and OAuth credentials.
- [`outputs.tf`](outputs.tf): Resource names, Collection ID, and post-deployment authorization instructions.
- [`terraform.tfvars.example`](terraform.tfvars.example): Example parameter inputs file.

---

## Deployment Steps

1. **Clone or navigate to the module directory**:
   ```bash
   cd tf-confluence
   ```

2. **Create `terraform.tfvars` from example**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Fill in your credentials in `terraform.tfvars`**:
   ```hcl
   project_id              = "your-gcp-project-id"
   location                = "us" # 'global', 'us', or 'eu'
   collection_id           = "confluence-federated-us"
   collection_display_name = "Confluence Cloud Federated Search US"

   confluence_instance_uri = "https://your-domain.atlassian.net"
   instance_id             = "your-atlassian-cloud-id"

   client_id     = "your-atlassian-oauth-client-id"
   client_secret = "your-atlassian-oauth-client-secret"
   ```

4. **Initialize and apply Terraform**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. **Complete One-Time OAuth Consent**:
   - Go to **Google Cloud Console -> Gemini Enterprise -> Data Stores**.
   - Select the newly created Confluence Cloud Data Store.
   - Click **Login** to complete the Atlassian OAuth sign-in and authorize live federated queries.

---

## References

- [Terraform Docs - google_discovery_engine_data_connector](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/discovery_engine_data_connector#confluence-1)
- [Google Cloud Docs - Set up Confluence Cloud Federated Data Store](https://docs.cloud.google.com/gemini/enterprise/docs/connectors/confluence-cloud/set-up-data-store#federated_search)
