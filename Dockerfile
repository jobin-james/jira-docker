FROM openjdk:8-alpine
ENV JIRA_HOME   /var/atlassian/jira
ENV JIRA_INSTALL    /opt/atlassian/jira
ENV JIRA_VERSION    8.1.0
# install package, pull Jira archive and extract
RUN set -x \
    && apk add --no-cache curl bash fontconfig ttf-dejavu  \
    && mkdir -p     "${JIRA_HOME}" \
    && mkdir -p     "${JIRA_INSTALL}" \
    && curl -Ls         "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -Ls         "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz" | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.47/mysql-connector-java-5.1.47-bin.jar" \
    && chmod -R 700     "${JIRA_INSTALL}" \
    && chmod -R 700     "${JIRA_HOME}" \
    && chown -R daemon:daemon 	${JIRA_INSTALL}/ \
    && chown -R daemon:daemon 	${JIRA_HOME}/ \
    && sed --in-place       "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e       "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"
#Copying setenv.sh - JVM parameter config file
COPY setenv.sh /opt/atlassian/jira/bin/setenv.sh
#Server config file
COPY server.xml /opt/atlassian/jira/conf/server.xml
#Change Jira install directory ownership to daemon
RUN chown -R daemon:daemon 	${JIRA_INSTALL}
#Using unprivilaged user account to run Jira
USER    daemon:daemon
#Expose default jira listening port 
EXPOSE  8080
#map home and log folder
VOLUME [ "/var/atlassian/jira" ]
#Work directiory 
WORKDIR /var/atlassian/jira
#Start jira instance
CMD [ "/opt/atlassian/jira/bin/start-jira.sh", "-fg" ]