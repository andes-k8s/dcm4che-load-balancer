global
    #debug
    daemon
    #log /dev/log local0 debug
    log 127.0.0.1   local0


    # Default SSL material locations
    # ca-base /etc/ssl/certs
    # crt-base /etc/ssl/private

    # Default ciphers to use on SSL-enabled listening sockets.
    # For more information, see ciphers(1SSL).
    ssl-default-bind-ciphers kEECDH+aRSA+AES:kRSA+AES:+AES256:RC4-SHA:!kEDH:!LOW:!EXP:!MD5:!aNULL:!eNULL

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000


frontend front_dcm4che
    bind *:443 ssl crt /etc/ssl/private/combined.pem alpn h2,http/1.1
    mode http
    compression algo gzip
    default_backend back_default


backend back_default
    mode http
    balance roundrobin
    option forwardfor
    http-request set-header X-Forwarded-Port %[dst_port]
    http-response set-header location %[res.hdr(location),regsub(:30443/,/)] if { res.hdr(location) -m found }
    compression algo gzip
    {{http}}
    


listen dicom
    bind *:2762
    mode tcp
    option tcplog
    balance roundrobin
    {{dicom}}



listen hl7
    bind *:2575
    mode tcp
    option tcplog
    balance roundrobin
    {{hl7}}



listen nema
    bind *:11112
    mode tcp
    option tcplog
    balance roundrobin
    {{nema}}
