variable "project_id" {
  type        = string
  description = "The Google Cloud Project ID where the Discovery Engine collection and connector will be created."
}

variable "location" {
  type        = string
  description = "The geographic location for the Discovery Engine data store. Supported values: 'global', 'us', or 'eu'."
  default     = "global"
}

variable "collection_id" {
  type        = string
  description = "The collection ID for the Discovery Engine Data Connector (RFC-1034 compliant, max 63 characters)."
  default     = "confluence-federated-collection"
}

variable "collection_display_name" {
  type        = string
  description = "Human-readable display name for the Collection in the Google Cloud Console."
  default     = "Confluence Cloud Federated Search"
}

variable "confluence_instance_uri" {
  type        = string
  description = "The base URL of your Confluence Cloud instance (e.g., https://your-domain.atlassian.net)."
}

variable "client_id" {
  type        = string
  description = "OAuth 2.0 Client ID generated from the Atlassian Developer Console app."
}

variable "client_secret" {
  type        = string
  description = "OAuth 2.0 Client Secret generated from the Atlassian Developer Console app."
  sensitive   = true
}

variable "instance_id" {
  type        = string
  description = "Optional Confluence Cloud unique Instance ID / cloudId (Required for some Atlassian OAuth setups)."
  default     = ""
}

variable "connector_modes" {
  type        = list(string)
  description = "Modes enabled for the connector. For Federated Search, set to ['FEDERATED'] or ['FEDERATED', 'ACTIONS']."
  default     = ["FEDERATED"]
}

variable "enable_actions" {
  type        = bool
  description = "Whether to enable Confluence Cloud actions (e.g., create/update comment, content) alongside federated search."
  default     = false
}

variable "enabled_actions_list" {
  type        = list(string)
  description = "List of actions to enable if enable_actions is true."
  default     = ["create_comment", "update_comment"]
}
