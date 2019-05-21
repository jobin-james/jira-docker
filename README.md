# Description

This docker file and docker compose used to create Jira docker image.
Using openjdk:8-alpine base image, downloading the jira tar from atlassian and extract to jira install dorectory and start jira from install directory

# Requirements:

Atlassian only support the version of Apache Tomcat that is bundled with Jira.
Can use OpenJDK the JDK (Java Development Kit) or JRE (Java Runtime Environment). OpenJDK Java 8- AdoptOpenJDK is not bundled with the Jira installers, and you need to install it on your own

# Database configuration:

Connecting Jira applications to MySQL 5.7
Create a database user which Jira will connect as, for example jiradbuser.
Create a database for Jira to store issues in, for example jiradb.
The database must have a character set of UTF8. To set it, enter the following command from within the MySQL command client:

```bash
    CREATE DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

```    
Make sure the user has permission to connect to the database

```bash
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,REFERENCES,ALTER,INDEX on <JIRADB>.* TO '<USERNAME>'@'<JIRA_SERVER_HOSTNAME>' IDENTIFIED BY '<PASSWORD>';
```
```bash
flush privileges;
```

# my.cnf:
```bash
[mysqld]
default-storage-engine=INNODB
character_set_server=utf8mb4
innodb_default_row_format=DYNAMIC
innodb_large_prefix=ON
innodb_file_format=Barracuda
innodb_log_file_size=2G
max_allowed_packet=256M
innodb_log_file_size=256M
```

### Copy the MySQL JDBC driver
Download the recommended MySQL driver JDBC Connector/J 5.1 from  https://dev.mysql.com/downloads/connector/j/5.1.html
Copy the driver to the following directory:
jira install directory/lib

Restart the Jira service.

### Configure Jira to connect to the database

There are two ways to configure your Jira server to connect to your MySQL database:
1. Setup wizard
2. Configuration tool (bin sub-directory of the Jira installation directory config.sh)

## Note: 
1. mysql docker is created just for testing
2. You can configure JIRA Java virtual machine by editing setenv.sh file and rebuild the docker
3. server.xml is used to configure jira tomcat server specific configuration