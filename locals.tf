# Helps to combine data, easier debug and remove complexity in the main resource.

locals {
  monitor_diagnostic_settings_list = [
    for index, monitor_diagnostic_setting in var.monitor_diagnostic_settings : {
      # Most will try and use key/value settings first, then try applicable defaults and then null as a last resort.

      ### Basic

      enabled_log                    = monitor_diagnostic_setting.enabled_log
      enabled_metric                 = monitor_diagnostic_setting.enabled_metric
      eventhub_name                  = monitor_diagnostic_setting.eventhub_name
      eventhub_authorization_rule_id = monitor_diagnostic_setting.eventhub_authorization_rule_id
      index                          = index # Added in case it's ever needed, since for_each/for loops don't have inherent indexes.
      log_analytics_destination_type = monitor_diagnostic_setting.log_analytics_destination_type
      log_analytics_workspace_id = (
        # If id is provided, use it directly.
        monitor_diagnostic_setting.log_analytics_workspace_id != null ? monitor_diagnostic_setting.log_analytics_workspace_id :
        # Otherwise, if name and resource group are provided, construct the id.
        monitor_diagnostic_setting.log_analytics_workspace_name != null && monitor_diagnostic_setting.log_analytics_workspace_resource_group_name != null ? format(
          "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.OperationalInsights/workspaces/%s",
          var.configuration.subscription_id,
          monitor_diagnostic_setting.log_analytics_workspace_resource_group_name,
          monitor_diagnostic_setting.log_analytics_workspace_name
        ) :
        # Otherwise, null.
        null
      )
      log_analytics_workspace_name = (
        # Use name if provided.
        monitor_diagnostic_setting.log_analytics_workspace_name != null ? monitor_diagnostic_setting.log_analytics_workspace_name :
        # If id is provided, split out name to populate name.
        # Using this will only work if resource has already been created, use of name/resource group is preferred for that reason.
        monitor_diagnostic_setting.log_analytics_workspace_id != null ? split("/", monitor_diagnostic_setting.log_analytics_workspace_id)[8] : null
      )
      log_analytics_workspace_resource_group_name = (
        # Use resource group if provided.
        monitor_diagnostic_setting.log_analytics_workspace_resource_group_name != null ? monitor_diagnostic_setting.log_analytics_workspace_resource_group_name :
        # If id is provided, split out resource group to populate resource group.
        # Using this will only work if resource has already been created, use of name/resource group is preferred for that reason.
        monitor_diagnostic_setting.log_analytics_workspace_id != null ? split("/", monitor_diagnostic_setting.log_analytics_workspace_id)[4] : null
      )
      name                = monitor_diagnostic_setting.name
      partner_solution_id = monitor_diagnostic_setting.partner_solution_id # Later we may add processing to construct this for commonly used resources.
      partner_solution_name = (
        # Use name if provided.
        monitor_diagnostic_setting.partner_solution_name != null ? monitor_diagnostic_setting.partner_solution_name :
        # If id is provided, split out name to populate name.
        # Using this will only work if resource has already been created, use of name/resource group is preferred for that reason.
        monitor_diagnostic_setting.partner_solution_id != null ? split("/", monitor_diagnostic_setting.partner_solution_id)[8] : null
      )
      partner_solution_resource_group_name = (
        # Use resource group if provided.
        monitor_diagnostic_setting.partner_solution_resource_group_name != null ? monitor_diagnostic_setting.partner_solution_resource_group_name :
        # If id is provided, split out resource group to populate resource group.
        # Using this will only work if resource has already been created, use of subscription/name/resource group is preferred for that reason.
        monitor_diagnostic_setting.partner_solution_id != null ? split("/", monitor_diagnostic_setting.partner_solution_id)[4] : null
      )
      partner_solution_subscription_id = (
        # Use subscription id if provided.
        monitor_diagnostic_setting.partner_solution_subscription_id != null ? monitor_diagnostic_setting.partner_solution_subscription_id :
        # If id is provided, split out subscription id to populate subscription id.
        # Using this will only work if resource has already been created, use of subscription/name/resource group is preferred for that reason.
        monitor_diagnostic_setting.partner_solution_id != null ? split("/", monitor_diagnostic_setting.partner_solution_id)[2] : null
      )
      storage_account_id = (
        # If id is provided, use it directly.
        monitor_diagnostic_setting.storage_account_id != null ? monitor_diagnostic_setting.storage_account_id :
        # Otherwise, if name and resource group are provided, construct the id.
        monitor_diagnostic_setting.storage_account_name != null && monitor_diagnostic_setting.storage_account_resource_group_name != null ? format(
          "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Storage/storageAccounts/%s",
          var.configuration.subscription_id,
          monitor_diagnostic_setting.storage_account_resource_group_name,
          monitor_diagnostic_setting.storage_account_name
        ) :
        # Otherwise, null.
        null
      )
      storage_account_name = (
        # Use name if provided.
        monitor_diagnostic_setting.storage_account_name != null ? monitor_diagnostic_setting.storage_account_name :
        # If id is provided, split out name to populate name.
        # Using this will only work if resource has already been created, use of name/resource group is preferred for that reason.
        monitor_diagnostic_setting.storage_account_id != null ? split("/", monitor_diagnostic_setting.storage_account_id)[8] : null
      )
      storage_account_resource_group_name = (
        # Use resource group if provided.
        monitor_diagnostic_setting.storage_account_resource_group_name != null ? monitor_diagnostic_setting.storage_account_resource_group_name :
        # If id is provided, split out resource group to populate resource group.
        # Using this will only work if resource has already been created, use of name/resource group is preferred for that reason.
        monitor_diagnostic_setting.storage_account_id != null ? split("/", monitor_diagnostic_setting.storage_account_id)[4] : null
      )

      target_name = (
        # Use name if provided.
        monitor_diagnostic_setting.target_name != null ? monitor_diagnostic_setting.target_name :
        # If id is provided, split out name to populate name.
        # Using this will only work if resource has already been created, use of name/resource group is preferred for that reason.
        monitor_diagnostic_setting.target_resource_id != null ? split("/", monitor_diagnostic_setting.target_resource_id)[8] : null
      )
      target_resource_group_name = (
        # Use resource group if provided.
        monitor_diagnostic_setting.target_resource_group_name != null ? monitor_diagnostic_setting.target_resource_group_name :
        # If id is provided, split out resource group to populate resource group.
        # Using this will only work if resource has already been created, use of name/resource group is preferred for that reason.
        monitor_diagnostic_setting.target_resource_id != null ? split("/", monitor_diagnostic_setting.target_resource_id)[4] : null
      )
      target_resource_id       = monitor_diagnostic_setting.target_resource_id # Later we may add processing to construct this for commonly used resources.
      target_sub_resource_path = monitor_diagnostic_setting.target_sub_resource_path
    }
  ]

  # Used to create unique id for for_each loops, as just using the name may not be unique.
  monitor_diagnostic_settings = {
    for monitor_diagnostic_setting in local.monitor_diagnostic_settings_list : monitor_diagnostic_setting.target_sub_resource_path == null ? format(
      "%s>%s>%s",
      monitor_diagnostic_setting.target_resource_group_name,
      monitor_diagnostic_setting.target_name,
      monitor_diagnostic_setting.name
      ) : format(
      "%s>%s>%s>%s",
      monitor_diagnostic_setting.target_resource_group_name,
      monitor_diagnostic_setting.target_name,
      monitor_diagnostic_setting.target_sub_resource_path,
      monitor_diagnostic_setting.name
    ) => monitor_diagnostic_setting
  }
}
