#### Dockerizing php development environemt with Aplpine 3.1.1 and php 7.4 

Docker set up for Wordpress 5.4( general LAMP) with alpine 3.1.1 and php 7.4. apache 2.4 and mysql 5.7

n this project, we are using:

> Alpine 3.1.1

> Web Server: Apache2.4

> Database Server: Mysql-server-5.7

> PHP version: PHP-7.4

To begin with, please install docker and docker-compose. 

> https://docs.docker.com/docker-for-windows/install/

> https://docs.docker.com/docker-for-mac/install/

Then follow the following steps:

1). Clone the project, got to the directory.

2). Build the docker image.

> docker-compose build (might have to run as admin or root user based docker user access)

3). Check the built image as:

> docker images

4). Run the containers from built image as:
> docker-compose up -d

5). Check the running docker containers by command:

> docker ps

You will see 
    > php container
    > mysql container
    > phpmyadmin container

6). Open http://localhost:8089 for phpmyadmin

7). Open http://localhost:8090 for php dev root.

8). Open http://localhost:8090/info.php for php info details

9) you can set up other projects in src folder in the cloned directory.

> if you want set a wordpress project, extract wordpress to src/ folder and continue installation with http://localhost:8090/wordpress 

10) Set mysql root credentials and name of the database to be created . Go to ~/docker-compose.yml and change mysql root password in database_server in:

>  MYSQL_USER: root
>  MYSQL_USER: dbpass