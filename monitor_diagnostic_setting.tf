### Requirements:

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54.0" # Tested on this provider version, but will allow future patch versions.
    }
  }
  required_version = "~> 1.14.0" # Tested on this Terraform CLI version, but will allow future patch versions.
}

### Data:

### Resources:

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = local.monitor_diagnostic_settings

  ### Basic

  dynamic "enabled_log" {
    for_each = each.value.enabled_log
    content {
      category       = enabled_log.value.category
      category_group = enabled_log.value.category_group
    }
  }
  dynamic "enabled_metric" {
    for_each = each.value.enabled_metric
    content {
      category = enabled_metric.value.category
    }
  }
  eventhub_name                  = each.value.eventhub_name
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  log_analytics_destination_type = each.value.log_analytics_destination_type
  name                           = each.value.name
  partner_solution_id            = each.value.partner_solution_id
  storage_account_id             = each.value.storage_account_id
  target_resource_id             = each.value.target_resource_id
}
