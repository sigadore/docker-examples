#!/bin/sh
# Performance configuration based on article https://geekflare.com/php-fpm-optimization/
echo '# Activate emergency_restart* and process_control_timeout parameters in /etc/php-fpm.conf'
emergency_restart_threshold='10'
emergency_restart_interval='1m'
process_control_timeout='10s'
# Note: In the following, the parameters are only changed IF they were commented out previously.
sed -i~ 's@^;[[:space:]]*\(emergency_restart_threshold\)[[:space:]]*=.*$@\1 = '"${emergency_restart_threshold}@;"\
's@^;[[:space:]]*\(emergency_restart_interval\)[[:space:]]*=.*$@\1 = '"${emergency_restart_interval}@;"\
's@^;[[:space:]]*\(process_control_timeout\)[[:space:]]*=.*$@\1 = '"${process_control_timeout}@" \
  /etc/php-fpm.conf 


if [ -e /etc/php-fpm.d/www.conf ]; then
  echo '# Adjust pm.* parameters of www domain from defaults in /etc/php-fpm.d/www.conf'
  # -- Initial values based on the number of connections to Oracle DB and that this is running in a container
  # -- Scaling would be performed by adding more containers
  pm_type='static'
  pm_max_children='20'
  listen_owner='nginx'
  listen_group='nginx'
  listen_php_fpm='/run/php-fpm/php-fpm.sock'

  sed -i~ 's@^[;]*\(pm\)[[:space:]]*=.*$@\1 = '"${pm_type}@;"\
's@^[;]*\(pm\.max_children\).*$@\1 = '"${pm_max_children}@;"\
's@^[;]*\(listen\.owner\).*$@\1 = '"${listen_owner}@;"\
's@^[;]*\(listen\.group\).*$@\1 = '"${listen_group}@;"\
's@^[;]*\(listen\)[[:space:]]*=.*$@\1 = '"${listen_php_fpm}@" \
   /etc/php-fpm.d/www.conf

# Add environments required for Instant Clinet access by php-oci8
  cat >>  /etc/php-fpm.d/www.conf <<EOF
env["TNSADMIN"]=\$TNSADMIN
env["LD_LIBRARY_PATH"]=\$LD_LIBRARY_PATH
env["ORACLE_HOME"]=\$ORACLE_HOME
EOF


# Add into the default nginx server support for php-fpm pass through
  cat > /etc/nginx/default.d/php-fpm_nginx.conf <<EOF
  location ~* \.php\$ {
    fastcgi_pass    unix:${listen_php_fpm};
    include         fastcgi_params;
    fastcgi_param   SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;
    fastcgi_param   SCRIPT_NAME        \$fastcgi_script_name;
  }
EOF

fi

# Update nginx root in default nginx server
nginx_root='/var/www/html'
sed  -i~ 's@^\([#]*[[[:space:]]*root[[:space:]][[:space:]]*\).*$@\1'"${nginx_root};@" \
   /etc/nginx/nginx.conf

