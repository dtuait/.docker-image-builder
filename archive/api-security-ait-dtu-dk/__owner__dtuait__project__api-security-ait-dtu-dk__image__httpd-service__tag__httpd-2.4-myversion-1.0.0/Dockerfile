FROM httpd:2.4

# Install these packages for all images, they are useful for debugging
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    iputils-ping \
    tree \
    zip \
    unzip \
    less \
    nano \
    iproute2 \
    iputils-ping

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

# Default httpd start command
CMD ["httpd-foreground"]