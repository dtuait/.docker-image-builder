# Start with the official Debian 10 base image
FROM debian:buster




##############                          ##############
##############    The basic stuff       ##############
##############       starts here        ##############
##############                          ##############




###### fix locales ######
# Install locales package
RUN apt-get update && \
    apt-get install -y locales

# Generate the en_US.UTF-8 locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LC_ALL=en_US.UTF-8

# Set environment variables for locale
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
###### fix locales ######



# Installing the packages that allows 
RUN apt-get update && apt-get install -y \
     tree \
     build-essential  \
     nano \
     zip \
     unzip \
     git \
     wget \
     curl \ 
     lsb-release \
     software-properties-common \
     apt-transport-https \
     ca-certificates


# set the time
RUN ln -fs /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# install the mail server








##############                          ##############
##############    The basic stuff       ##############
##############       ends here          ##############
##############                          ##############



##############                          ##############
##############    The perl stuff        ##############
##############       starts here        ##############
##############                          ##############

RUN apt-get update && \
    apt-get install -y \ 
        perl \
        perl-debug \
        cpanminus \
        libanyevent-perl \
        libclass-refresh-perl \
        perl-doc \ 
        libidn2-dev

RUN yes | cpan Compiler::Lexer

RUN apt-get install -y \
    libdata-dump-perl \
    libio-aio-perl \
    libjson-perl \
    libmoose-perl \
    libpadwalker-perl \
    libscalar-list-utils-perl \
    libcoro-perl \
    libexpat1-dev

RUN yes | cpan Perl::LanguageServer

RUN cpan Net::LibIDN2
RUN cpan Net::DNS
RUN cpan Net::Subnet
RUN cpan Net::LDAPS
RUN cpan REST::Client
RUN cpan Net::IP
RUN cpan XML::Parser
RUN cpan XML::SAX::Expat
RUN cpan XML::Simple
RUN cpan DBI
RUN cpan Template
RUN cpan JSON



##############                          ##############
##############    The perl stuff        ##############
##############       ends here          ##############
##############                          ##############

