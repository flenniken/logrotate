FROM debian
MAINTAINER Steve Flenniken

RUN apt-get update \
  && apt-get install -y cron sudo nano man logrotate less libtext-lorem-perl

# Create user steve with sudo permissions and no password.
RUN mkdir -p /etc/sudoers.d \
  && echo "steve ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/steve \
  && chmod 440 /etc/sudoers.d/steve \
  && adduser --disabled-password --gecos '' steve \
  && usermod -aG sudo steve \
  && echo 'steve:testp' | chpasswd

# Switch to user steve for following commands.
USER steve
WORKDIR /home/steve

# Copy all the config files to the container's home directory.
COPY --chown=steve:steve config .

# Make the script runable and add the cron job to the system.
RUN sudo chmod +x script.sh \
  && crontab mycron

# Start cron and bash.
CMD sudo service cron start \
  && /bin/bash
