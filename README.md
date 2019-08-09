# Wildfly-MySQL

## Wildfly
Version: 17.0.1.Final

## Mysql Driver
Version: 8.0.17

## docker-compose example
```Dockerfile
version: "3.7"
services:
    wildfly:
        restart: always
        build: ./
        ports:
          - "8080:8080"
          - "9990:9990"
        volumes:
            - ./docker-vols/data:/tmp
        command: /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
        environment:
            MYSQL_DATASOURCE_NAME: MySqlDS
            MYSQL_DATASOURCE_DRIVER_NAME: mysql
            MYSQL_DATASOURCE_JNDI_NAME: java:/datasources/MySqlDS
            MYSQL_DATASOURCE_URL: jdbc:mysql://mysql:3306/mysql
            MYSQL_DATASOURCE_USER: root
            MYSQL_DATASOURCE_PASSWORD: example
            MYSQL_DATASOURCE_MAX_POOL_SIZE: 25
            MYSQL_DATASOURCE_BLOCK_TIMEOUT: 5000

    mysql:
        image: mysql:latest
        command: --default-authentication-plugin=mysql_native_password
        restart: always
        environment:
            MYSQL_ROOT_PASSWORD: example

    adminer:
        image: adminer
        restart: always
        ports:
            - 8090:8080
```

## Dockerfile example for new project
```Dockerfile
####################################################################################
# BASE IMAGE
####################################################################################
FROM moorea/wildfly-mysql:latest
####################################################################################
# ADD APP WAR
####################################################################################
ADD target/*.war /opt/jboss/wildfly/standalone/deployments/
####################################################################################
```
