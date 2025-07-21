FROM nginx:alpine

# Install supervisord + fix permissions
RUN apk add --no-cache supervisor && \
    mkdir -p /logs && \
    chown -R nginx:nginx /logs && \
    chmod -R 755 /logs

# Copy files
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
COPY log-monitor.sh /log-monitor.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set execute permissions
RUN chmod +x /log-monitor.sh

# Expose port 80 (critical for web access)
EXPOSE 80

# Run supervisord (as root to manage processes)
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
