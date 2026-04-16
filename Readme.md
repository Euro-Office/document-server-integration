## Integration examples

These test examples are simple document management systems that can be built into your application for testing.
Do NOT use these integration examples on your own server without proper code modifications!
In case you enabled any of the test examples, disable it before going for production.

These examples show the way to integrate [Euro-Office Docs][1] into your own website or application using one of the programming languages.
The package contains examples written in .Net (C# MVC), .Net (C#), Go, Java, Java Spring, Node.js, PHP, PHP (Laravel), Python and Ruby.

You should change `http://documentserver` to your server address in these files:
* [.Net (C# MVC)](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/csharp-mvc) - `web/documentserver-example/csharp-mvc/web.appsettings.config`
* [.Net (C#)](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/csharp) - `web/documentserver-example/csharp/settings.config`
* [Go](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/go) - `web\documentserver-example\go\config\configuration.json`
* [Java](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/java) - `web/documentserver-example/java/src/main/resources/settings.properties`
* [Java Spring](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/java-spring) - `web/documentserver-example/java-spring/src/main/resources/application.properties`
* [Node.js](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/nodejs) - `web/documentserver-example/nodejs/config/default.json`
* [PHP](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/php) - `web/documentserver-example/php/src/configuration/ConfigurationManager.php`
* [PHP (Laravel)](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/php-laravel) - `web/documentserver-example/php-laravel/.env.example`
* [Python](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/python) - `web/documentserver-example/python/src/configuration/configuration.py`
* [Ruby](https://github.com/Euro-Office/document-server-integration/tree/main/web/documentserver-example/ruby) - `web/documentserver-example/ruby/app/configuration/configuration.rb`


## Quick Start — minimal Docker test environment

The repository ships a `docker-compose.yml` that starts a self-contained
Euro-Office DocumentServer with the Node.js integration example enabled
automatically. No extra configuration or manual service start is required.

**Prerequisites:** Docker with the Compose plugin (v2).

**1. Start the container:**

```bash
docker compose up -d
```

**2. Wait until the server is ready** — monitor the logs:

```bash
docker logs -f eo-documentserver
```

The server is ready when you see:

```
INFO success: docservice entered RUNNING state
```

**3. Open the example in your browser:**

```
http://localhost:8080/example/
```

To open a specific file type directly in the editor:

```
http://localhost:8080/example/editor?fileExt=docx&userid=uid-1&lang=en&directUrl=false
```

| Parameter | Description |
|-----------|-------------|
| `fileExt` | Extension of the new blank document (`docx`, `xlsx`, `pptx`) |
| `userid`  | Any user identifier (e.g. `uid-1`) |
| `lang`    | UI language — exact locale (`en-US`) or two-letter code with `default` fallback (`en`) |
| `directUrl` | Set `true` to pass the file URL directly to the browser |

**Stop and remove the container:**

```bash
docker compose down
```

> **Security note:** The compose file sets `JWT_SECRET=secret`. This is
> intentionally insecure and is only suitable for local development and
> testing. Never expose this setup to a public network.


## API methods for test examples

The methods described below are available for all of the test examples.

### POST `/upload`

|                        |                                                              |
| ---------------------- | ------------------------------------------------------------ |
| **Summary**            | Upload file to test example via request                      |
| **URL**                | /upload                                                      |
| **Method**             | POST                                                         |
| **Request<br>Headers** | `Content-Type: multipart/form-data`                          |
| **Request<br>Body**    | `uploadedFile=@<filepath>`<br> `filepath` - file for uploading<br />Multipart body with the file binary contents |
| **Response**           | **Code:** 200 OK <br />**Content on success:**<br /> `{ "filename": <filename>}`<br />**Content on error:**<br /> `{ "error": "Uploaded file not found" }` <br /> Or <br /> `{ "error": "File size is incorrect" }` |
| **Sample**             | `curl -X POST -F uploadedFile=@filename.docx http://localhost/upload` |


### DELETE `/file`

|                    |                                                              |
| ------------------ | ------------------------------------------------------------ |
| **Summary**        | Delete one file or all files                                 |
| **URL**            | /file                                                        |
| **Method**         | DELETE                                                       |
| ****URL Params**** | **Optional:**<br /> `filename=[string]` - file for deleting. <br /> *WARNING! Without this parameter, all files will be deleted* |
| **Response**       | **Code:** 200 OK <br /> **Success:**<br /> `{ "success": true }` |
| **Sample**         | **Delete one file:**<br />`curl -X DELETE http://localhost/file?filename=filename.docx`<br />**Delete all files:**<br />`curl -X DELETE http://localhost/file`<br /> |


### GET `/files`

|                    |                                                              |
| ------------------ | ------------------------------------------------------------ |
| **Summary**        | Get information about all files                              |
| **URL**            | /files                                                       |
| **Method**         | GET                                                          |
| **Response**       | **Code:** 200 OK <br /> **Success:**<br /> `[{ "version": <file_version>, "id": <file_id>, "contentLength": <file_size_in_kilobytes>, "pureContentLength": <file_size_in_bytes>, "title": <file_name>, "updated": <last_change_date>}, ..., {...}]` |
| **Sample**         | `curl -X GET http://localhost/files/`                        |


### GET `/files/file/{fileId}`

|                    |                                                              |
| ------------------ | ------------------------------------------------------------ |
| **Summary**        | Get information about a file by file id                      |
| **URL**            | /files/file/{fileId}                                         |
| **Method**         | GET                                                          |
| **Response**       | **Code:** 200 OK <br />**Content on success:**<br /> `[{ "version": <file_version>, "id": <file_id>, "contentLength": <file_size_in_kilobytes>, "pureContentLength": <file_size_in_bytes>, "title": <file_name>, "updated": <last_change_date>}]`<br />**Content on error:**<br /> `"File not found"` |
| **Sample**         | `curl -X GET http://localhost/files/{fileId}`                |

## Important security info

Please keep in mind the following security aspects when you are using test examples:

* There is no protection of the storage from unauthorized access since there is no need for authorization.
* There are no checks against parameter substitution in links, since the parameters are generated by the code according to the pre-arranged scripts.
* There are no data checks in requests of saving the file after editing, since each test example is intended for requests only from Euro-Office Document Server.
* There are no prohibitions on using test examples from other sites, since they are intended to interact with Euro-Office Document Server from another domain.

## Project Information

Official website: [https://github.com/Euro-Office](https://github.com/Euro-Office)

Code repository: [https://github.com/Euro-Office/document-server-integration](https://github.com/Euro-Office/document-server-integration "https://github.com/Euro-Office/document-server-integration")


## User Feedback and Support

If you have any problems with or questions about [Euro-Office Document Server][1]

  [1]: https://github.com/Euro-Office/DocumentServer
  
## License

document-server-integration is released under the Apache-2.0 License. See the LICENSE file for more information.
