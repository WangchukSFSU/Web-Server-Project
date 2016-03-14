## Instructions to configure project

1. Download project
2.  Change file paths in files: config/httpd.config, public_html/protected/.htaccess (Provide absolute paths)
    In httpd.config, change paths for: DocumentRoot ,LogFile,ScriptAlias,Alias
    In .htaccess file : AuthUserFile
3.  The default username and password provided are: jrob,mysecret. They can be changed in public_html/protected/.htpasswd file
    For default credentials, the value to be provided in authoization header of request is: Basic anJvYjpteXNlY3JldA==
4.  The port configured for webserver is 56789
     From local machine, URL to be accessed is : localhost:56789/
5.  To run program, enter into project directory in terminal and type following to  : ruby webserver.rb
    
