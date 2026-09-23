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
  value       = "After Terraform provisions the federated connectors, open the Gemini Enterprise Console under Data Stores, select '${google_discovery_engine_data_connector.confluence_federated_connector.collection_display_name}' and '${google_discovery_engine_data_connector.slack_federated_connector.collection_display_name}', and perform the initial OAuth login to complete end-user authorization."
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

