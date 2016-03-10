FROM ubuntu:14.04
MAINTAINER Marlon Silva Carvalho "marlon.carvalho@gmail.com"

RUN apt-get update && apt-get -y install wget

RUN wget http://demoiselle.c3sl.ufpr.br/ComunidadeFrameworkDemoiselle.asc && \
    wget http://demoiselle.c3sl.ufpr.br/public_key.asc

RUN apt-key add ComunidadeFrameworkDemoiselle.asc && \
    apt-key add public_key.asc

RUN echo "deb http://demoiselle.c3sl.ufpr.br universal stable" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y demoiselle-eclipse-4.4.2

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN apt-get install -y libgtk2.0-0

ADD run /usr/local/bin/eclipse

RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /opt/demoiselle/ide/eclipse-4.4.2/eclipse
