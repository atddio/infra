# Dockerfile for setting up a working haskell development environment
#
FROM ubuntu:trusty 
MAINTAINER arnaud@capital-match.com

RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:hvr/ghc && \
    apt-get update && apt-get install -y ghc-7.8.3 cabal-install-1.20

ENV LANG C.UTF-8
ENV PATH /opt/cabal/1.20/bin:/opt/ghc/7.8.3/bin:$PATH

RUN cabal update

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y build-essential git locales
RUN locale-gen en_US.UTF-8

# The following 
# Install Oracle Java 8
# Java is needed in order to build UI
RUN \
  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common python-software-properties && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
  apt-get update -q && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer && \
  apt-get clean

# Install Clojure 1.6
RUN \
  mkdir -p /usr/share/clojure/bin && \
  mkdir -p /usr/share/clojure/lib && \
  wget -O /usr/share/clojure/lib/clojure-1.6.0.jar http://central.maven.org/maven2/org/clojure/clojure/1.6.0/clojure-1.6.0.jar

RUN \
  echo "#!/bin/sh" > /usr/share/clojure/bin/clojure \
  echo "exec java -cp /usr/share/clojure/lib/clojure-1.6.0.jar clojure.main" >> /usr/share/clojure/bin/clojure \
  chmod +x /usr/share/clojure/bin/clojure && \
  ln -s /usr/share/clojure/bin/clojure /usr/bin/clojure

# Install leiningen
RUN \
  mkdir -p /usr/share/leiningen &&\
  wget -O /usr/share/leiningen/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
  chmod +x /usr/share/leiningen/lein && \
  ln -s /usr/share/leiningen/lein /usr/bin/lein && \
  lein

# create dedicated user for dev
RUN groupadd -g 1001 curry \
    && useradd -g 1001 -u 1001 -m -s /bin/bash curry \
    && chown -R curry /home/curry

RUN apt-get install zlib1g-dev libtinfo-dev
# install cabal stuff as user curry
USER curry
ENV HOME  /home/curry

RUN cabal update && cabal install cabal-install && \
    cabal -j8 install happy

RUN echo "export PATH=\$HOME/.cabal/bin:\$PATH" >> ~/.bashrc

# reset user to root
USER root
