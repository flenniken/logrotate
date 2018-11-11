# Log when the script runs.
echo "script.sh ran at $(date)" >> /home/steve/cron.log 2>&1

# Uncomment this line to run logrotate.
#logrotate -s /home/steve/state.txt /home/steve/rotate.conf
