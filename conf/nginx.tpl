
events {
  worker_connections  4096;  ## Default: 1024
}

http {
  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  #access_log   /var/logs/access.log  main;
  access_log off;
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts


    server { # HTTP
        listen  443 ssl;
        server_name  pacs{{domain}} keycloak-pacs{{domain}} console-pacs{{domain}} visor{{domain}} kibana-pacs{{domain}};
        ssl_certificate /etc/ssl/private/fullchain.pem; 
        ssl_certificate_key /etc/ssl/private/privkey.pem;
        gzip on;
        #gzip_min_length 1000;
        gunzip on;
        #access_log   /var/logs/hpn.access.log  main;
        gzip_proxied no-cache no-store private expired auth;
        proxy_set_header Host $host;

        location / {
            proxy_pass https://kubernetes_http;
        }
    }

    upstream kubernetes_http {
        {{http}}
    }  
}

stream {
    server { # DICOM
        listen  2762;        
        health_check;
        proxy_pass kubernetes_dicom;
    }
    upstream kubernetes_dicom {
        {{dicom}}
    } 

    server { # HL7
        listen  2575;        
        health_check;
        proxy_pass kubernetes_hl7;
    }
    upstream kubernetes_hl7 {
        {{hl7}}
    }  

    server { # NEMA
        listen  11112;        
        health_check;
        proxy_pass kubernetes_nema;
    }
    upstream kubernetes_nema {
        {{nema}}
    }          

}