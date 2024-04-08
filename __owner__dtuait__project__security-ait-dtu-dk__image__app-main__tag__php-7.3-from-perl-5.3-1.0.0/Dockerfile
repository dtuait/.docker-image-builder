FROM dtuait/security-ait-dtu-dk-app-main:perl-5.3-base-1.0.0

##############                          ##############
##############    The php-apache stuff  ##############
##############       starts here        ##############
##############                          ##############



### install apache2 and php7.3 ####
RUN DEBIAN_FRONTEND=noninteractive apt install apache2 -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
RUN apt update && apt install -y curl software-properties-common apt-transport-https lsb-release ca-certificates
RUN curl -fsSL https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.3.list
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y php7.3 -o Dpkg::Options::="--force-confold"
RUN apt install -y php7.3-xdebug php7.3-mysql
### install apache2 and php7.3 ####


### setup composer ####
RUN cd /tmp && curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    HASH="$(curl -sS https://composer.github.io/installer.sig)" && \
    if echo "$HASH composer-setup.php" | sha384sum -c - | grep "composer-setup.php: OK"; then \
        php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
        rm /tmp/composer-setup.php; \
    fi
### setup composer ####


# install php7.3 extensions
RUN apt-get install -y \
    php7.3-curl


# setup cas for apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libapache2-mod-auth-cas -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
RUN a2enmod auth_cas

# setup perl-cgi for apache2
RUN apt-get install -y libapache2-mod-perl2




#### setup ability to access sccm database (msssql) #### 
RUN echo "deb [arch=amd64] https://packages.microsoft.com/debian/10/prod buster main" > /etc/apt/sources.list.d/microsoft-prod.list
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN apt update
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN apt update && ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN apt-get install -y libdbd-odbc-perl



##############                          ##############
##############    The php-apache stuff  ##############
##############       ends here          ##############
##############                          ##############

