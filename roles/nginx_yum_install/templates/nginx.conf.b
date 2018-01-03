user                    {{ nginx_user | default(nginx) }};
error_log               {{ nginx_error_log | default(/var/log/nginx/nginx_error.log warn) }};
pid                     {{ nginx_pidfile | default(/var/run/nginx.pid)}};

worker_processes        {{ worker_processes | default(auto) }};
worker_cpu_affinity     {{ worker_cpu_affinity | default(auto) }};
worker_rlimit_nofile    {{ worker_rlimit_nofile | default(65533) }};

events {
    worker_connections  {{ worker_connections | default(1024) }};
{% if nginx_event_model %}    
    use                 {{ nginx_event_model | default(epoll) }};
{% endif %}
{% if multi_accept %} 
    multi_accept        {{ multi_accept | default(off) }};
{% endif %}
}


http {

    include                 "{{ nginx_base_conf_path | default(/etc/nginx) }}/mime.types";
    default_type            application/octet-stream;


    server_tokens           {{ server_tokens  | default(off) }};
    sendfile                {{ sendfile  | default(on) }};
    tcp_nopush              {{ tcp_nopush  | default(on) }};
    tcp_nodelay             {{ tcp_nodelay  | default(on) }};

    keepalive_timeout       {{ keepalive_timeout | default(65) }};
    keepalive_requests      {{ keepalive_requests | default(100)  }};
    client_header_timeout   {{ client_header_timeout | default(15) }};
    client_body_timeout     {{ client_body_timeout | default(60) }};
    send_timeout            {{ send_timeout | default(60) }};


    types_hash_max_size             {{ types_hash_max_size | default(2048) }};

    server_names_hash_max_size      {{ server_names_hash_max_size }};
    server_names_hash_bucket_size   {{ server_names_hash_bucket_size }};
    
    client_header_buffer_size       {{ client_header_buffer_size | default(32k) }};
    large_client_header_buffers     {{ client_header_buffer_size | default(8 128k) }};
    client_max_body_size            {{ client_max_body_size | default(8M) }};



{% if http_extra_options %}
    {{ http_extra_options|indent(4, False) }}
{% endif %}

    include "{{ nginx_http_conf_path }}/*.conf";

{% if nginx_http_conf_path != nginx_http_conf_d_path %}
    include "{{ nginx_http_conf_d_path }}/*.conf";
{% endif %}




}

