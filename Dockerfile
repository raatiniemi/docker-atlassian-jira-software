FROM java:8
MAINTAINER Tobias Raatiniemi <raatiniemi@gmail.com>

ENV JIRA_HOME /var/atlassian/jira
ENV JIRA_INSTALL /opt/atlassian/jira
ENV JIRA_VERSION 7.1.8

RUN set -x \
	&& apt-get update \
	&& mkdir -p "${JIRA_HOME}" \
	&& mkdir -p "${JIRA_HOME}/caches/indexes" \
	&& chmod -R 700 "${JIRA_HOME}" \
	&& mkdir -p "${JIRA_INSTALL}/conf/Catalina" \
	&& curl -Ls "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}-jira-${JIRA_VERSION}.tar.gz" \
		| tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
	&& chmod -R 700 "${JIRA_INSTALL}/conf" \
	&& chmod -R 700 "${JIRA_INSTALL}/logs" \
	&& chmod -R 700 "${JIRA_INSTALL}/temp" \
	&& chmod -R 700 "${JIRA_INSTALL}/work" \
	&& sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
	&& echo -e "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"

# Expose default HTTP connector port.
EXPOSE 8080

VOLUME ["${JIRA_HOME}", "${JIRA_INSTALL}"]

WORKDIR ${JIRA_HOME}
CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]
