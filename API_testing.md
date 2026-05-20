https://raw.githubusercontent.com/z5jt/API-documentation-Wordlist/refs/heads/main/API-Documentation-Wordlist/api-documentation-endpoint.txt - good swagger wordlist
api.svoevse.ru

Application Programming Interfaces
### Discovering API documentation
1. Use Burp Scanner / Crawler
2. Review the endpoints that may refer to API documentation
	 `/api`
	 `/swagger/index.html`
	 `/openapi.json`
3. If you identify an endpoint for a resource, make sure to investigate the base path for example if endpoint is `/api/swagger/v1/users/123`, u wanna check:
	 `/api/swagger/v1`
	 `/api/swagger`
	 `/api`
#### Lab: Exploiting an API endpoint using documentation
1. Login and review API in burp
2. Try to change the email and see following req from Crawler/Proxy
   ```json
   PATCH /api/user/wiener
   Host: host
   {"email":"some@ex.ample"}
   ```
3. Try `GET /api/user/carlos`
4.  `DELETE /api/user/carlos `
### Identifying API endpoints
- Look for patterns that suggest API endpoints in the URL structure, such as `/api/`
- Look out for JavaScript files. These can contain references to API endpoints that you haven't triggered directly via the web browser
	May use JS Link Finder BApp for burp