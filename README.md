# espress NodeMCU http-server

Version: 0.2.0

Ultra-Lightweight and modular Node.js like http server for NodeMCU.  
Emphasizes code-as-a-config.

Features:  
 * ApiKey authentication module
 * Easy service of static pages
 * Easy custom webservices with your own lua code
 * GET, POST PUT, DELETE, OPTIONS, HEAD supported
 * Querystring, headers, method, form and body parser
 * Completely customizable. Make your own plugin work in a few seconds.
 * Inspired by Node.js Express
 * ESP8266 friendly : Can take between 10 and 20 Kb of memory for typical setups
 
## Setup

Transfer the relevant content with any upload tool (we recommend using https://www.npmjs.com/package/nodemcu-tool).  
A binary pre-compiled version is available in bin/ folder. 

## Recipes

### How to use

 ```lua
  local espress = require 'espress'
  local port = 80
  -- Initialize a server creation (lazy)
  local server = espress.createserver()
  -- Declare desired plugins one by one
  -- syntax is server:use("plugin" [, opts)
  server:use("auth_api_key.lc", {apikey = "1234-abcd", includes = "/api"})
  server:use("routes_auto.lc")
  server:listen(port)
 ```

### Req/Res API
#### Request
 req = {  
  params,  
  headers,  
  method,  
  body  
 }
 
##### req.params
 Holds the querystring or the forms parameters.
 Example: for http://host/api/computers?id=1234  
 ```lua
   local id = tonumber(req.params["id"]) -- 1234
 ```
 If forms or querystring have multiple values for the same key, req.params.field will be a table with all values stored within.
 
##### req.headers
 Holds the request headers.  
 N.B.: header name is stored in lower-case
 ```lua
   local contenttype = req.headers["content-type"] -- "application/json"
 ```
 
##### req.method
 Contains the request method: "GET", "POST", "PUT", "DELETE", "OPTIONS", "HEAD"
 
##### req.body
 Contains the body parsed into a string.  
 N.B.: You have the liberty of parsing this string to whatever you feel comfortable with. It is a voluntary choice not to parse it into JSON or other formats.
 Sample parsers for form and json will be available soon in the samples.  
 
#### Response
 
 Example :
 res = {
  conn,  
  send,  
  sendfile,  
  sendredirect,  
  statuscode,  
  headers,  
  addheader  
 }
 
##### res.conn
 The http connection socket. Please refer to NodeMCU's API for more details
  
##### res.send
 Send payload in response and close connection after. The payload is sent in one chunk and length should not exceed 1460 bytes.
 If payload is bigger than 1460, please use res.sendfile instead.
 
 Example:  
 ```lua
  local content = "{message: \"Hello world\"}"
  res:send(content)
 ```
 
##### res.sendfile
 Send static file in response and close connection after. The payload is sent into multiple chunks of 1460 bytes, and should be used to process all static content. 
 
 Example:
 ```lua
   res:sendfile("static/404-not-found.html")
 ```
 
##### res.sendredirect
 Redirect user to another URL 
 
 Example:
 ```lua
   res:sendredirect("/registration_success.html")
 ```
 
##### res.statuscode
 Sets the response http statuscode.
  
 Example:
 ```lua
   res.statuscode = 102
 ```
 
##### res.headers
 Contains the response headers. Use for read-only. To add or edit response headers, rather use res.addheader
 
##### res.addheader
 Add or edit response header.
 
 Example:  
 ```lua
   res.addheader("Content-Type", "application/json")
 ```
 
 

### Plugins
Available plugins are:  
 * auth_api_key : implementation for an Api-Key header-based authentication
 * routes_auto : automatic routing using your /static and /routes sub-folders (recommended)
 * routes_custom : to perform advanced routing
 
#### Plugin auth-api-key
 This plugin will intercept all requests and look for an X-Api-Key header OR an &api-key parameter in querystring.  
 Valid options for this plugin are:  
 * apikey: the desired apikey to secure  
 * includes: a uri prefix to which auth will be enabled (will exclude all others)  
 * excludes: a uri prefix to which auth will be bypassed (will include all others)  
 
 ```lua
  server:use("auth_api_key.lc", {apikey = "1234-abcd", includes = "/api"})
 ```
 
 The following responses can be expected :  
 * **400 BAD-REQUEST** if neither the X-Api-Key header nor the api-key parameter were provided  
 * **401 UNAUTHORIZED** if the provided value does not match the one in the options **{apikey = "1234-abcd"}**    
 * Forward to next handler if everything went well
 
#### Plugin routes-auto
The plugin will automatically parse the request url and lookup for the corresponding files depending on their name.

Two kinds of content are supported :

##### Static files (webcontent)
Your webpages, css, images, and static content should be stored as static/filename.ext onto the NodeMCU filesystem.  

For instance:  
static/index.html  
static/style.css  
static/logo.png  
static/script.js  

##### Dynamic content
Your API scripts should be stored as routes/path.method.lc (example: routes/foo.post.lc, routes/bar.get.lc ...) and should hold the following function:  
 ```lua
 return function(req, res)
  -- your code here
  res:addheader("Content-Type", "application/json; charset=utf-8")
  res:send("{foo:\"bar\"}")
  -- end of your code
 end
 ```

The scripts will be available under the following uri: host/api/path  
For instance: 
routes/foo.get.lc <=> [GET] http://host/api/foo  
routes/bar.post.lc <=> [POST] http://host/api/bar  

Don't forget to take a look at the req and res API.  
Samples are available into the sample/ subfolder

#### Plugin routes-custom
This plugin uses a node.js like route handler.  
Declarations are made this way:
 ```lua
 local router = require 'router'
 router.get("/computers", "routes/computers.get.lc")
 router.post("/user/register", "routes/register.get.lc")
 router.delete("/user/employee", "routes/employee-revoke.delete.lc")
 return router.handler 
 ```

Save your own script with your own routes and load it using server:use()

## License
This project is licensed under The MIT License (MIT).

Copyright (c) 2015 Loïc Ortola

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



## Contribute 
Any form of contribution is welcome: Issues, Pull-Requests, Feature requests.  
Twitter: **@Loicortola**
