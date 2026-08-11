terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  project               = var.project_id
  user_project_override = true
  billing_project       = var.project_id
  region                = var.location == "global" ? "us-central1" : var.location
}

# ------------------------------------------------------------------------------
# Secret Manager for Confluence OAuth 2.0 Client Secret
# ------------------------------------------------------------------------------

resource "google_secret_manager_secret" "confluence_client_secret" {
  secret_id = "confluence-oauth-client-secret-${var.collection_id}"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "confluence_client_secret" {
  secret      = google_secret_manager_secret.confluence_client_secret.id
  secret_data = var.client_secret
}

# Optional Secret Manager secret for Instance ID if provided
resource "google_secret_manager_secret" "confluence_instance_id" {
  count     = var.instance_id != "" ? 1 : 0
  secret_id = "confluence-instance-id-${var.collection_id}"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "confluence_instance_id" {
  count       = var.instance_id != "" ? 1 : 0
  secret      = google_secret_manager_secret.confluence_instance_id[0].id
  secret_data = var.instance_id
}

# ------------------------------------------------------------------------------
# Discovery Engine Data Connector - Confluence Federated Search Mode
# ------------------------------------------------------------------------------

resource "google_discovery_engine_data_connector" "confluence_federated_connector" {
  project                 = var.project_id
  location                = var.location
  collection_id           = var.collection_id
  collection_display_name = var.collection_display_name
  data_source             = "confluence"
  connector_modes         = var.enable_actions ? ["FEDERATED", "ACTIONS"] : var.connector_modes

  refresh_interval  = "86400s"
  sync_mode         = "PERIODIC"
  static_ip_enabled = false

  # Connector Parameters for Atlassian OAuth 2.0 Federated Authentication
  params = merge(
    {
      auth_type     = "OAUTH"
      instance_uri  = var.confluence_instance_uri
      client_id     = var.client_id
      client_secret = google_secret_manager_secret_version.confluence_client_secret.name
    },
    var.instance_id != "" ? {
      instance_id = google_secret_manager_secret_version.confluence_instance_id[0].name
    } : {}
  )

  # Destination configuration for Confluence endpoint
  destination_configs {
    key = "url"
    destinations {
      host = var.confluence_instance_uri
    }
  }

  # Federated Search Entities for Confluence
  entities {
    entity_name = "page"
  }

  entities {
    entity_name = "space"
  }

  entities {
    entity_name = "blog"
  }

  entities {
    entity_name = "attachment"
  }

  entities {
    entity_name = "comment"
  }

  # Action configuration if ACTIONS mode is enabled
  dynamic "bap_config" {
    for_each = var.enable_actions ? [1] : []
    content {
      supported_connector_modes = ["ACTIONS"]
      enabled_actions           = var.enabled_actions_list
    }
  }

  depends_on = [
    google_secret_manager_secret_version.confluence_client_secret
  ]
}
