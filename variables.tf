variable "project_id" {
  type        = string
  description = "The Google Cloud Project ID where the Discovery Engine collection and connector will be created."
}

variable "location" {
  type        = string
  description = "The geographic location for the Discovery Engine data store. Supported values: 'global', 'us', or 'eu'."
  default     = "global"
}

variable "confluence_location" {
  type        = string
  description = "The geographic location for the Confluence data connector."
  default     = "us"
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

# ------------------------------------------------------------------------------
# Slack Federated Connector Variables
# ------------------------------------------------------------------------------

variable "slack_collection_id" {
  type        = string
  description = "The collection ID for the Slack Discovery Engine Data Connector (RFC-1034 compliant, max 63 characters)."
  default     = "slack-federated-collection"
}

variable "slack_collection_display_name" {
  type        = string
  description = "Human-readable display name for the Slack Collection in the Google Cloud Console."
  default     = "Slack Federated Search"
}

variable "slack_team_id" {
  type        = string
  description = "Optional Slack Team ID (e.g., T01234567) to restrict users to a specific Slack workspace."
  default     = ""
}

variable "slack_static_ip_enabled" {
  type        = bool
  description = "Whether to enable static IP addresses for the Slack connector."
  default     = false
}

variable "slack_connector_modes" {
  type        = list(string)
  description = "Modes enabled for the Slack connector."
  default     = ["FEDERATED", "ACTIONS"]
}

variable "slack_enable_actions" {
  type        = bool
  description = "Whether to enable Slack actions alongside federated search."
  default     = false
}

variable "slack_enabled_actions_list" {
  type        = list(string)
  description = "List of Slack actions to enable if slack_enable_actions is true."
  default     = ["send_message"]
}


