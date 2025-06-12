FROM xtofalex/najaeda AS builder

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY najaeda_scripts /najaeda_scripts

# Set default entrypoint
ENTRYPOINT ["/entrypoint.sh"]