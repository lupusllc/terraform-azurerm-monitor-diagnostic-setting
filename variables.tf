### Defaults

### Required

### Dependencies

# This data source from root is used because using data calls in child modules can inadvertently cause resource recreation.
variable "configuration" {
  description = "Configuration data such as Tenant ID and Subscription ID."
  nullable    = false
  type = object({
    client_id       = string
    id              = string
    object_id       = string
    subscription_id = string
    tenant_id       = string
  })
}

### Resources

variable "monitor_diagnostic_settings" {
  default     = [] # Defaults to an empty list.
  description = "Monitor diagnostics settings, to send target logging/diagnostics of resources to their eventhub, log analytics workspace, partner solution, and/or storage account."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type = list(object({
    ### Basic

    enabled_log = optional(list(object({
      # Either category or category_group must be specified.
      category       = optional(string, null)
      category_group = optional(string, null)
    })), [])
    enabled_metric = optional(list(object({
      category = string
    })), [])
    eventhub_authorization_rule_id              = optional(string, null) # The ID of the event hub authorization rule.
    eventhub_name                               = optional(string, null) # If sending to an event hub.
    log_analytics_destination_type              = optional(string, null) # Dedicated, AzureMonitor. The type of log analytics destination.
    log_analytics_workspace_id                  = optional(string, null) # If sending to a log analytics workspace.
    log_analytics_workspace_name                = optional(string, null) # The name of the log analytics workspace.
    log_analytics_workspace_resource_group_name = optional(string, null) # The resource group of the log analytics workspace.
    name                                        = optional(string, null) # The name of the diagnostic setting, this will be set automatically if not provided.
    partner_solution_id                         = optional(string, null) # The partner solution ID.
    partner_solution_name                       = optional(string, null) # The name of the partner solution.
    partner_solution_resource_group_name        = optional(string, null) # The resource group of the partner solution.
    partner_solution_subscription_id            = optional(string, null) # The subscription ID of the partner solution.
    storage_account_id                          = optional(string, null) # If sending to a storage account.
    storage_account_name                        = optional(string, null) # The name of the storage account.
    storage_account_resource_group_name         = optional(string, null) # The resource group of the storage account.
    target_resource_id                          = string                 # The ID of the resource to monitor.
    target_name                                 = optional(string, null) # The name of the target resource.
    target_resource_group_name                  = optional(string, null) # The resource group of the target resource.
  }))
}
