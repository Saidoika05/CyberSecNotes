# Switch
#### Basic
``enable`` - start the CLI
`exit` - exit the CLI
enable secret password_for_enable_mode - set root password
username username privilege 15 secret password
#### Telnet config
`line vty 0 15` - virtual terminal setting mode
``transport input telnet`` - set the desired protocol 
``login local`` - auth enabled

 **IP setting**
```java
interface Vlan 1
no shutdown
ip address 192.168.0.1 255.255.255.0
```
**Cable connect password protection**
```java
line console 0
login local
```

``write memory`` - save config changes to memory
# Vlan
#### Creating VLAN
```c++
enable //start the CLI
config //open configuration prompt
Switch(config)#vlan 10
Switch(config-vlan)#name vlan_sales
Switch#show vlan
```

#### Configure PC to access VLAN
Do this in the switch CLI
Configure interfaces FA1, FA2
```C++
Switch(config)#interface range fa0/1-2
Switch(config-if-range)#switchport mode access
Switch(config-if-range)#switchport access vlan 10
```

#### Set TRUNK
```
Switch#conf t
Switch(config)#interface fa0/16
Switch(config-if)#switchport mode trunk
Switch(config-if)#switchport trunk allowed vlan 10,20
```
