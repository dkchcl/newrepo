resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    data.azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

    # 🚀 Nginx Install script (cloud-init)
custom_data = base64encode(<<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

cat <<EOT | sudo tee /var/www/html/index.html
<h1 style="color: #1E90FF; font-weight: bold; text-align: center;">
 🚀 Welcome to Nginx on VM Scale Set 🌍
</h1>

<h2 style="color: #FF4500; font-weight: bold; text-align: center;">
 🔥 Keep Learning, Keep Building & Keep Automating – Welcome to the DevOps World! ⚙️💻
</h2>
EOT
EOF
)

}
