FROM dtuait/security-ait-dtu-dk-app-main:php-7.3-from-perl-5.3-1.0.0

# Avoid interactive dialog (e.g., from Postfix) by setting DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages in one layer to keep the image size small
RUN apt-get update && \
    apt-get install -y sudo postfix postfix-pcre mailutils && \
    apt-key adv --fetch-keys 'https://packages.sury.org/php/apt.gpg' && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for internal use (to clarify, these are for configuring the development environment)
# These ARGs are for setting up the Linux user inside the container, not for external use
ARG LINUX_USER=aitsoc # Internal Linux username, used for container interaction
ARG LINUX_GROUP=aitsoc # Linux group for the user
ARG LINUX_PASSWORD=aitsoc # Password for the Linux user
ARG LINUX_HOME=/home/aitsoc # Home directory for the Linux user
ARG LINUX_SHELL=/bin/bash # Default shell for the Linux user
ARG LINUX_AITSOC_GROUP_MEMBERS=www-data # Additional groups the Linux user should be part of

# Set up email recipient user, indicating the user that will receive all system emails
ARG MAIL_RECIPIENT_USER=vicre # User to receive emails from sendmail

# Preconfigure Postfix
RUN echo "postfix postfix/mailserver string satellite" | debconf-set-selections && \
    echo "postfix postfix/mailname string security-$MAIL_RECIPIENT_USER.ait.dtu.dk" | debconf-set-selections && \
    echo "postfix postfix/relayhost string smtp.ait.dtu.dk" | debconf-set-selections && \
    echo "/.*@.*/  $MAIL_RECIPIENT_USER@dtu.dk" | tee /etc/postfix/virtual && \
    echo "virtual_alias_maps = pcre:/etc/postfix/virtual" >> /etc/postfix/main.cf

# Create and configure the Linux user, group, and permissions
RUN groupadd -g 1000 $LINUX_GROUP && \
    useradd -m -u 1000 -g 1000 -G sudo,staff,root -s $LINUX_SHELL $LINUX_USER && \
    echo "$LINUX_USER:$LINUX_PASSWORD" | chpasswd && \
    echo "$LINUX_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$LINUX_USER && \
    chmod 0440 /etc/sudoers.d/$LINUX_USER && \
    chown -R $LINUX_USER:$LINUX_GROUP $LINUX_HOME && \
    usermod -a -G $LINUX_AITSOC_GROUP_MEMBERS $LINUX_USER

# Add Apache's user (`www-data`) to the `$LINUX_GROUP` to allow necessary access
RUN usermod -a -G $LINUX_GROUP www-data

# Set the default user for when connecting to the container
USER $LINUX_USER

# Command to run Apache in the foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]