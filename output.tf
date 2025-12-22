output "monitor_diagnostic_settings" {
  description = "The monitor diagnostic settings."
  value       = azurerm_monitor_diagnostic_setting.this
}

### Debug Only

output "var_monitor_diagnostic_settings" {
  value = var.monitor_diagnostic_settings
}

output "local_monitor_diagnostic_settings" {
  value = local.monitor_diagnostic_settings
}
