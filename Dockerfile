####################################################################################
# JBOSS WILDFLY
####################################################################################
FROM jboss/wildfly:17.0.1.Final
RUN /opt/jboss/wildfly/bin/add-user.sh admin 1234 --silent
####################################################################################
# INSTALL MYSQL DRIVER
####################################################################################
ENV MYSQL_CONNECTOR_VERSION 8.0.17
RUN  curl --location --output /opt/jboss/mysql.jar --url http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar
RUN mkdir -p META-INF/services
RUN echo "com.mysql.cj.jdbc.Driver" > META-INF/services/java.sql.Driver 
RUN jar uf /opt/jboss/mysql.jar META-INF
ADD add-mysql-driver.cli /opt/jboss/add-mysql-driver.cli
RUN /opt/jboss/wildfly/bin/jboss-cli.sh --file=/opt/jboss/add-mysql-driver.cli
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history
####################################################################################
# ADD MYSQL DATASOURCE
####################################################################################
ADD add-datasource.cli /opt/jboss/add-datasource.cli
RUN /opt/jboss/wildfly/bin/jboss-cli.sh --file=/opt/jboss/add-datasource.cli
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history
####################################################################################
# ADD APP WAR
####################################################################################
# ADD target/*.war /opt/jboss/wildfly/standalone/deployments/
####################################################################################
# HOW TO BUILD WAR
####################################################################################
# # docker run -it --rm -v "$PWD":/usr/src/app -v "$HOME"/.m2:/root/.m2 -w /usr/src/app maven:3-jdk-8-alpine mvn install -Dmaven.test.skip=true
####################################################################################