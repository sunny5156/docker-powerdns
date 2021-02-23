#FROM centos:centos7
FROM hub.docker.thinkchanges.cn/suntek/vue-msf-docker:1.2.9
MAINTAINER sunny5156 <sunny5156@qq.com>

RUN yum install -y libxml2-devel xmlsec1-devel xmlsec1-openssl-devel libtool-ltdl-devel \
    && curl -o /etc/yum.repos.d/powerdns-rec-43.repo https://repo.powerdns.com/repo-files/centos-rec-43.repo \
    && curl -o /etc/yum.repos.d/powerdns-auth-43.repo https://repo.powerdns.com/repo-files/centos-auth-43.repo

RUN yum install -y pdns pdns-recursor pdns-backend-mysql mariadb-server mariadb mariadb-devel \
    && chmod a+x /usr/sbin/pdns* \
    && mkdir -p /var/run/pdns-recursor /var/run/pdns-server 

COPY ./default_config.py  /vue-msf/data/www/default_config.py

RUN export LC_ALL=en_US.utf-8 \
    && export LANG=en_US.utf-8 \
    && pip install -U virtualenv  \
    && git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git /vue-msf/data/www/powerdns-admin/ \
    && cd /vue-msf/data/www/powerdns-admin \
    && virtualenv -p python3 flask \
    && . ./flask/bin/activate \
    && pip install python-dotenv\
    && pip install -r requirements.txt \
    && rm -f /vue-msf/data/www/powerdns-admin/powerdnsadmin/default_config.py \
    && cp /vue-msf/data/www/default_config.py /vue-msf/data/www/powerdns-admin/powerdnsadmin/default_config.py \
    #&& sed -i "s|LOG_FILE = 'logfile.log'|LOG_FILE = ''|g" /vue-msf/data/www/powerdns-admin/config.py; \
    #sed -i "s|BASIC_ENABLED = True|BASIC_ENABLED = False|g" /vue-msf/data/www/powerdns-admin/config.py; \
    #sed -i "s|SIGNUP_ENABLED = True|SIGNUP_ENABLED = False|g" /vue-msf/data/www/powerdns-admin/config.py; \
    #sed -i "s|PDNS_VERSION = '3.4.7'|PDNS_VERSION = '4.0.4'|g" /vue-msf/data/www/powerdns-admin/config.py; \
    #sed -i "s|PRETTY_IPV6_PTR = False|PRETTY_IPV6_PTR = True|g" /vue-msf/data/www/powerdns-admin/config.py \
    && export FLASK_APP=powerdnsadmin/__init__.py \
    && flask db upgrade \
    && yarn install --pure-lockfile \
    && flask assets build

RUN mv /etc/pdns/pdns.conf  /etc/pdns/pdns.conf.bak \
    && mv /etc/pdns-recursor/recursor.conf  /etc/pdns-recursor/recursor.conf.bak

COPY ./config/nginx/pdns-admin.conf /vue-msf/nginx/conf.d/pdns-admin.conf
COPY ./config/pdns/pdns.conf /etc/pdns/pdns.conf
COPY ./config/pdns-recursor/recursor.conf /etc/pdns-recursor/recursor.conf
COPY ./config/pdns-recursor/forward-zones.conf /etc/pdns-recursor/forward-zones.conf
COPY ./run.sh /vue-msf/data/www/powerdns-admin/run.sh
COPY ./config/supervisor/powerdns-admin.conf /vue-msf/supervisor/conf.d/powerdns-admin.conf
COPY ./config/supervisor/powerdns-server.conf /vue-msf/supervisor/conf.d/powerdns-server.conf
COPY ./config/supervisor/powerdns-recursor.conf /vue-msf/supervisor/conf.d/powerdns-recursor.conf
