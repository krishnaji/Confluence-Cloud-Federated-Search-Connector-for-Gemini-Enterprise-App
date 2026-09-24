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
  location                = var.confluence_location
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

  lifecycle {
    ignore_changes = [collection_display_name, action_config]
  }

  depends_on = [
    google_secret_manager_secret_version.confluence_client_secret
  ]
}

# ------------------------------------------------------------------------------
# Discovery Engine Data Connector - Slack Federated Search Mode
# ------------------------------------------------------------------------------
resource "google_discovery_engine_data_connector" "slack_federated_connector" {
  project                 = var.project_id
  location                = var.location
  collection_id           = var.slack_collection_id
  collection_display_name = var.slack_collection_display_name
  data_source             = "slack"

  connector_modes   = ["FEDERATED", "ACTIONS"]
  refresh_interval  = "86400s"
  sync_mode         = "PERIODIC"
 

  # Connector Parameters from Console payload
  params = {
    unused_auth_param = "unused"
    auth_type         = "AUTHORIZATION_TYPE_UNDEFINED"
  }

  # Action configuration captured from Console payload
  action_config {
    action_params = merge(
      {
        auth_type = "OAUTH"
        auth_key  = "OAuth"
      },
      var.slack_team_id != "" ? {
        team_id = var.slack_team_id
      } : {}
    )
    create_bap_connection = true
  }

  # Federated Search Entities for Slack
  entities {
    entity_name = "conversation"
  }

  entities {
    entity_name = "file"
  }

  entities {
    entity_name = "message"
  }

  lifecycle {
    ignore_changes = [bap_config, destination_configs, connector_modes]
  }
}

# ------------------------------------------------------------------------------
# Discovery Engine Data Connector - PagerDuty Federated Search Mode
# ------------------------------------------------------------------------------

resource "google_discovery_engine_data_connector" "pagerduty_federated_connector" {
  project                 = var.project_id
  location                = var.location
  collection_id           = var.pagerduty_collection_id
  collection_display_name = var.pagerduty_collection_display_name
  data_source             = "pagerduty"

  connector_modes   = ["FEDERATED"]
  refresh_interval  = "86400s"
  sync_mode         = "PERIODIC"
  static_ip_enabled = var.pagerduty_static_ip_enabled

  # Connector Parameters
  params = {
    client_id     = var.pagerduty_client_id
    client_secret = var.pagerduty_client_secret
    auth_type     = "OAUTH"
  }

  # Action configuration captured from Console payload
  action_config {
    action_params = {
      client_id     = var.pagerduty_client_id
      client_secret = var.pagerduty_client_secret
   
      auth_type     = "OAUTH"
      auth_key      = "OAuth"
    }
    create_bap_connection = true
  }

  # Federated Search Entities for PagerDuty
  entities {
    entity_name = "incidents"
  }

  entities {
    entity_name = "services"
  }

  entities {
    entity_name = "users"
  }

  lifecycle {
    ignore_changes = [bap_config]
  }
}

# ------------------------------------------------------------------------------
# Discovery Engine Data Connector - Jira Federated Search Mode
# ------------------------------------------------------------------------------

resource "google_discovery_engine_data_connector" "jira_federated_connector" {
  project                 = var.project_id
  location                = var.location
  collection_id           = var.jira_collection_id
  collection_display_name = var.jira_collection_display_name
  data_source             = "jira"

  connector_modes   = ["FEDERATED"]
  refresh_interval  = "86400s"
  sync_mode         = "PERIODIC"
  static_ip_enabled = var.jira_static_ip_enabled

  # Connector Parameters
  params = {
    instance_uri  = var.jira_instance_uri
    instance_id   = var.jira_instance_id
    client_id     = var.jira_client_id
    client_secret = var.jira_client_secret
    refresh_token = "unused"
    auth_type     = "OAUTH"
  }

  destination_configs {
    key = "url"
    destinations {
      host = var.jira_instance_uri
    }
  }

  # Action configuration captured from Console payload
  action_config {
    action_params = {
      instance_uri          = var.jira_instance_uri
      client_id             = var.jira_client_id
      client_secret         = var.jira_client_secret
      instance_id           = var.jira_instance_id
      auth_type             = "OAUTH"
      auth_key              = "OAuth"
      include_custom_fields = "false"
    }
    create_bap_connection = true
  }

  # Federated Search Entities for Jira
  entities {
    entity_name = "project"
  }

  entities {
    entity_name = "attachment"
  }

  entities {
    entity_name = "comment"
  }

  entities {
    entity_name = "issue"
  }

  entities {
    entity_name = "bug"
  }

  entities {
    entity_name = "epic"
  }

  entities {
    entity_name = "story"
  }

  entities {
    entity_name = "task"
  }

  entities {
    entity_name = "worklog"
  }

  entities {
    entity_name = "board"
  }

  lifecycle {
    ignore_changes = [bap_config]
  }
}


