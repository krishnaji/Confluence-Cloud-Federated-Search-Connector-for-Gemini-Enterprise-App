output "data_connector_name" {
  description = "The full resource name of the Confluence Federated Data Connector."
  value       = google_discovery_engine_data_connector.confluence_federated_connector.name
}

output "collection_id" {
  description = "The Collection ID managing the federated data store."
  value       = google_discovery_engine_data_connector.confluence_federated_connector.collection_id
}

output "data_connector_state" {
  description = "The state of the Data Connector."
  value       = google_discovery_engine_data_connector.confluence_federated_connector.state
}

output "federated_search_next_steps" {
  description = "Important instructions for completing Federated Search authorization."
  value       = "After Terraform provisions the federated connectors, open the Gemini Enterprise Console under Data Stores, select '${var.collection_display_name}', '${var.slack_collection_display_name}', '${var.pagerduty_collection_display_name}', '${var.jira_collection_display_name}', '${var.gmail_collection_display_name}', '${var.google_calendar_collection_display_name}', and '${var.google_drive_collection_display_name}', and perform the initial OAuth login to complete end-user authorization."
}

output "slack_data_connector_name" {
  description = "The full resource name of the Slack Federated Data Connector."
  value       = google_discovery_engine_data_connector.slack_federated_connector.name
}

output "slack_collection_id" {
  description = "The Collection ID managing the Slack federated data store."
  value       = google_discovery_engine_data_connector.slack_federated_connector.collection_id
}

output "slack_data_connector_state" {
  description = "The state of the Slack Data Connector."
  value       = google_discovery_engine_data_connector.slack_federated_connector.state
}

output "pagerduty_data_connector_name" {
  description = "The full resource name of the PagerDuty Federated Data Connector."
  value       = google_discovery_engine_data_connector.pagerduty_federated_connector.name
}

output "pagerduty_collection_id" {
  description = "The Collection ID managing the PagerDuty federated data store."
  value       = google_discovery_engine_data_connector.pagerduty_federated_connector.collection_id
}

output "pagerduty_data_connector_state" {
  description = "The state of the PagerDuty Data Connector."
  value       = google_discovery_engine_data_connector.pagerduty_federated_connector.state
}

output "jira_data_connector_name" {
  description = "The full resource name of the Jira Federated Data Connector."
  value       = google_discovery_engine_data_connector.jira_federated_connector.name
}

output "jira_collection_id" {
  description = "The Collection ID managing the Jira federated data store."
  value       = google_discovery_engine_data_connector.jira_federated_connector.collection_id
}

output "jira_data_connector_state" {
  description = "The state of the Jira Data Connector."
  value       = google_discovery_engine_data_connector.jira_federated_connector.state
}

output "gmail_data_connector_name" {
  description = "The full resource name of the Gmail Federated Data Connector."
  value       = google_discovery_engine_data_connector.gmail_federated_connector.name
}

output "gmail_collection_id" {
  description = "The Collection ID managing the Gmail federated data store."
  value       = google_discovery_engine_data_connector.gmail_federated_connector.collection_id
}

output "gmail_data_connector_state" {
  description = "The state of the Gmail Data Connector."
  value       = google_discovery_engine_data_connector.gmail_federated_connector.state
}

output "google_calendar_data_connector_name" {
  description = "The full resource name of the Google Calendar Federated Data Connector."
  value       = google_discovery_engine_data_connector.google_calendar_federated_connector.name
}

output "google_calendar_collection_id" {
  description = "The Collection ID managing the Google Calendar federated data store."
  value       = google_discovery_engine_data_connector.google_calendar_federated_connector.collection_id
}

output "google_calendar_data_connector_state" {
  description = "The state of the Google Calendar Data Connector."
  value       = google_discovery_engine_data_connector.google_calendar_federated_connector.state
}

output "google_drive_data_connector_name" {
  description = "The full resource name of the Google Drive Federated Data Connector."
  value       = google_discovery_engine_data_connector.google_drive_federated_connector.name
}

output "google_drive_collection_id" {
  description = "The Collection ID managing the Google Drive federated data store."
  value       = google_discovery_engine_data_connector.google_drive_federated_connector.collection_id
}

output "google_drive_data_connector_state" {
  description = "The state of the Google Drive Data Connector."
  value       = google_discovery_engine_data_connector.google_drive_federated_connector.state
}

