locals {
  name = "onprem-ad"
}

resource "azurerm_public_ip" "default" {
  name                = "pip-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "windows" {
  name                = "nic-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "windows"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_windows_virtual_machine" "active_directory" {
  name                  = "vm-${local.name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = "ad-admin"
  admin_password        = var.password
  network_interface_ids = [azurerm_network_interface.windows.id]

  os_disk {
    name                 = "osdisk-${local.name}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "CustomScriptExtension" {
  name                 = "CustomScriptExtension"
  virtual_machine_id   = azurerm_windows_virtual_machine.active_directory.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.8"
  settings             = <<SETTINGS
        {
            "fileUris": [
                "${var.ps1_url}"
                ],
            "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File userdata.ps1"
        }
    SETTINGS
}
