# Docs: https://github.com/phusion/passenger-docker

# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/CHANGELOG.md for
# a list of version numbers.
FROM phusion/passenger-ruby33

# Set correct environment variables.
ENV HOME /root
ENV RACK_ENV development
ENV BASIC_USER_NM italijancic
ENV BASIC_PASSWORD test1234
ENV DB_TYPE ymlstore
ENV DB_PATH ../../db/db

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default
# Add the nginx site and config
ADD nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD nginx/custom_nginx.conf /etc/nginx/conf.d/custom_nginx.conf
ADD nginx/env.conf /etc/nginx/main.d/env.conf

# Install bundle of gems
WORKDIR /tmp
ADD ./Gemfile /tmp/
ADD ./Gemfile.lock /tmp/
RUN bundle install

# Add the Rails app
COPY --chown=app:app . /home/app/webapp

# Set app dir as current work dir
WORKDIR /home/app/webapp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
