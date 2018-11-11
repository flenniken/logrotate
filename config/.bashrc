
alias ll='ls -l'

# Append (fill) 1 to 100 paragraphs of lorem ipsum text to my.log.
alias f='lorem -p $(shuf -i 1-100 -n 1) >>my.log;ll'

# Test logrotate
alias t='logrotate -d -s /home/steve/state.txt /home/steve/rotate.conf'

# Run logrotate
alias r='logrotate -s /home/steve/state.txt /home/steve/rotate.conf;ll'
