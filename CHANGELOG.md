### Espress Changelog

#### 0.4.0
 Changes:
 * Implemented request buffer for multiple request-handling
 * Added gzip support
 * Refactoring

#### 0.3.0
 Changes:
 * Fixed body parsing bug
 * Fixed concurrent file reading bug
 * Added not_found as default behaviour
 * Added res:sendredirect method
 * Implemented global error handler
 * Implemented forms parsing
 * Added simple-website-with-forms sample
 * Added api with cjson sample
 * Added 500, 302 status codes to server default uploads
 * Updated docs and upload scripts
 
 API Changes:

Instead of 
```lua
 espress:createserver(port)
 
 espress:use("plugin1.lc")
 -- ...
```

Write the following
```lua
 -- The server creation becomes lazy
 espress:createserver()
 
 espress:use("plugin1.lc")
 -- ...
 espress:listen(port)
```

#### 0.2.0
 Changes:
 * Added default route "/" to index.html
 * Buffering headers before sending
 * Added mime types for .ico files
 
#### 0.1.0
 Added base project