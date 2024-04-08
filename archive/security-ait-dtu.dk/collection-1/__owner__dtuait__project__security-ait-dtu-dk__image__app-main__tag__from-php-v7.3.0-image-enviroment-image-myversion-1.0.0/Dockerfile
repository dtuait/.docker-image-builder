FROM dtuait/security-ait-dtu-dk-app-main:from-perl-base-image-php-v7.3.0-myversion-1.0.0







# run this to build the image
# docker build --build-arg LINUX_USER=aitsoc --build-arg LINUX_GROUP=aitsoc --build-arg LINUX_PASSWORD=aitsoc --build-arg LINUX_HOME=/home/aitsoc --build-arg LINUX_SHELL=/bin/bash --build-arg LINUX_GROUP_MEMBERS=www-data

# Install sudo
RUN apt-get update && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/*

# Fix the expired key for sury.org PHP repository
RUN apt-key adv --fetch-keys 'https://packages.sury.org/php/apt.gpg'

# Update package lists and install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y postfix postfix-pcre mailutils

# # Setup environment variables from .env file
ARG LINUX_USER=aitsoc
ARG LINUX_GROUP=aitsoc
ARG LINUX_PASSWORD=aitsoc
ARG LINUX_HOME=/home/aitsoc
ARG LINUX_SHELL=/bin/bash
ARG LINUX_AITSOC_GROUP_MEMBERS=www-data

### setup mail ####
# Preconfigure postfix selection
# TODO - account for who is developing
# Install necessary packages
# Set debconf selections for postfix
RUN echo "postfix postfix/mailserver string satellite" | debconf-set-selections
RUN echo "postfix postfix/mailname string security-vicre.ait.dtu.dk" | debconf-set-selections
RUN echo "postfix postfix/relayhost string smtp.ait.dtu.dk" | debconf-set-selections

# Update package lists and install packages
RUN cat /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y postfix postfix-pcre mailutils

# Configure postfix - this can be changed in postCommand.sh
RUN echo "/.*@.*/  vicre@dtu.dk" > /etc/postfix/virtual
RUN echo "virtual_alias_maps = pcre:/etc/postfix/virtual" >> /etc/postfix/main.cf

# Cleanup to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

### setup mail ####


# Create user, setup home directory permissions, and add user to necessary groups
RUN groupadd -g 1000 $LINUX_GROUP && \
    useradd -m -u 1000 -g 1000 -G sudo,staff,root -s $LINUX_SHELL $LINUX_USER && \
    echo "$LINUX_USER:$LINUX_PASSWORD" | chpasswd && \
    echo "$LINUX_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$LINUX_USER && \
    chmod 0440 /etc/sudoers.d/$LINUX_USER && \
    chown -R $LINUX_USER:$LINUX_GROUP $LINUX_HOME && \
    usermod -a -G $LINUX_AITSOC_GROUP_MEMBERS $LINUX_USER


# Grant proper permissions for Apache to access the `aitsoc` user's public_html directory
# Assuming `www-data` is the user and group Apache runs as
# RUN chown -R $LINUX_USER:www-data $LINUX_HOME/public_html && \
#     chmod -R 750 $LINUX_HOME/public_html && \
#     find $LINUX_HOME/public_html -type d -exec chmod 755 {} \; && \
#     find $LINUX_HOME/public_html -name "*.pl" -exec chmod 755 {} \;

# Add www-data user to aitsoc group
RUN usermod -a -G aitsoc www-data

# Set default user to aitsoc when connecting to the container
USER $LINUX_USER

#
CMD ["/usr/sbin/apache2ctl", "-D FOREGROUND"]
