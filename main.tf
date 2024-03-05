resource "azurerm_resource_group" "scbMarch" {
  name     = "scbMarch-resources"
  location = "Central India"
}

resource "azurerm_virtual_network" "scbMarch" {
  name                = "scbMarch-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.scbMarch.location
  resource_group_name = azurerm_resource_group.scbMarch.name
}

resource "azurerm_subnet" "scbMarch" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.scbMarch.name
  virtual_network_name = azurerm_virtual_network.scbMarch.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "scbMarch" {
  name                = "scbMarch-nic"
  location            = azurerm_resource_group.scbMarch.location
  resource_group_name = azurerm_resource_group.scbMarch.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.scbMarch.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "scbMarch" {
  name                = "scbMarch-machine"
  resource_group_name = azurerm_resource_group.scbMarch.name
  location            = azurerm_resource_group.scbMarch.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.scbMarch.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}