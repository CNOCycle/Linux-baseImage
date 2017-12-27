FROM ubuntu:17.10 as build-stage
# run firefox in docker
# ref: http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
# ref: https://github.com/playniuniu/docker-gui-firefox
# >> docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix firefox
# >> xhost + local:docker && docker run --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix firefox

# set variables
ENV USERNAME firefox
ENV SED_APT_OLD "\ http:\/\/[A-Za-z.]*.ubuntu.com\/ubuntu\/\?\ "
ENV SED_APT_NEW "\ mirror:\/\/mirrors.ubuntu.com\/mirrors.txt\ "
ENV APT_PACKAGES firefox dbus-x11 libcanberra-gtk-module 
#libcanberra-gtk3-module

# install packages
RUN sed -i "s/${SED_APT_OLD}/${SED_APT_NEW}/g" /etc/apt/sources.list `#get fast server` && \
    apt-get update && \
    apt-get install -qq --no-install-recommends ${APT_PACKAGES} && \
    rm -rf /var/lib/apt/lists/*

# set workdir to user's home
WORKDIR /home/${USERNAME}

# creat a non-root user and chown all files to user
RUN useradd -m -s /sbin/nologin ${USERNAME} && \
    chown -R ${USERNAME} /home/${USERNAME}

# switch user
USER ${USERNAME}
CMD /usr/bin/firefox
