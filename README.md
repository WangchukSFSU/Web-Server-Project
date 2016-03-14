
## Specifications
The purpose of this project is to write a web server application capable of a subset of the HyperText Transfer Protocol.

It provides following functionality:

1. Read standard configuration files for use in responding to client requests
1. Parse HTTP Requests
1. Generate and send HTTP Responses
1. Respond to multiple simultaneous requests through the use of threads
1. Execute server side processes to handle server side scripts
1. Support simple authentication

### 1. Read Standard Server Configuration
Web Server reads configuration files that define the behavior of the server. It uses two config files of Apache Web Server application: httpd.conf, and mime.types.

#### httpd.conf 
A file that provides configuration options for the server in a key value formate=, where the first entry on each line is the configuration option, and the second is the configuration value.  The following table lists the httpd.conf keys web server supports, along with a brief description of the value. 

| Key            | Value 
|----------------|-------
| ServerRoot     | Absolute path to the root of the server installation
| Listen         | Port number that the server will listen on for incoming requests
| DocumentRoot   | Absolute path to the root of the document tree
| LogFile        | Absolute path to the file where logs should be written to
| Alias          | Two values: the first value is a symbolic path, the second value is the absolute path that the symbolic path resolves to
| ScriptAlias    | Two values: the first value is a symbolic path to a script directory, the second value is the absolute path that the symbolic path resolves to, from which scripts will be executed
| AccessFileName | The name of the file that is used to determine whether or not a directory tree requires authentication for access (default is .htaccess)
| DirectoryIndex | One or more filenames to be used as the resource name in the event that a file is not provided explicitly in the request.

#### mime.types
A file that provides a mapping between file extension and mime type.  The server uses this file in order to properly set the Content-Type header in the HTTP Response.  The format of this file is any number of lines, where each line contains the following information:

_mime-type file-extension_

### 2. Parse HTTP Requests
The server appropriately responds to the following request methods: **GET**, **HEAD**, **DELETE**, and **PUT**. 

### 3. Generate and Send HTTP Responses
The server is able to generate all of the following response codes: **200**, **201**, **400**, **401**, **403**, **404**, **500**. 

### 4. Respond to Multiple Requests Simultaneously (Threaded)
The server handles simultaneous requests by using multithreading. 

### 5. Execute Server Scripts
The server is able to execute resources that have been requested in a ScriptAlias’ed directory. 

### 6. Support Simple Authentication
The server supports basic authentication. Permission to access a given resource is determined by the presence of the file specified by the AccessFileName directive in the httpd.conf file anywhere in the directory tree of the requested resource.  This file contains directives in key value pairs that specify authentication information for a given set of resources.  The following table lists the .htaccess keys web server supports, along with a brief description of the value.

| Key          | Value
|--------------|------
| AuthUserFile | Absolute path to the location of the file containing the username and password pairs, in .htpassword format
| AuthType     | The only value supported is ‘Basic’
| AuthName     | The name that will be displayed in the authentication window provided by clients
| Require      | Specifies the user or group that can access a resource.  valid-user is a special value that indicates that any user listed in the AuthUserFile can access the resource

