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
### Identifying API Endpoints
**xnLinkFinder**
**GoLinkFinder EVO**
**JSHunter**
**Rac-Js**
**ShadowJS**
**Katana**
**GAU**
My custom script katana + parsing
#### HTTP methods
- `GET` - Retrieves data from a resource.
- `PATCH` - Applies partial changes to a resource.
- `OPTIONS` - Retrieves information on the types of request methods that can be used on a resource.
**Note**: To change the content type, modify the `Content-Type` header, then reformat the request body accordingly
#### Lab: Finding and exploiting an unused API endpoint
1. find `/api/products/1/price` and send to repeater
2. add `Content-Type: application/json`
3. ```
   PATCH /api/products/1/price
   {"price":0,"message":"This item is in high demand - 6 purchased in the last 1h"}
   ```
