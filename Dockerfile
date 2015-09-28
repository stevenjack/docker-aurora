FROM java
MAINTAINER Steven Jack <stevenmajack@gmail.com>

RUN apt-get update
RUN apt-get install build-essential -y

RUN git clone http://git-wip-us.apache.org/repos/asf/aurora.git
WORKDIR aurora
RUN ./gradlew distZip
RUN unzip dist/distributions/aurora-scheduler-*.zip -d /usr/local
RUN ln -nfs "$(ls -dt /usr/local/aurora-scheduler-* | head -1)" /usr/local/aurora-scheduler
COPY start.sh /usr/bin/aurora
RUN chmod u+x /usr/bin/aurora

ENTRYPOINT aurora 
