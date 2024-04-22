## Overview
Build simple HTTPD server

## How to build
```
docker build -t simple-httpd .
```

## How to run

```
docker run -d -p 8080:80 --name docker-httpd simple-httpd
```

Can access on http://localhost:8080