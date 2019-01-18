yum install git
yum -y install gcc gcc-c++
yum install -y pcre pcre-devel
yum install -y zlib zlib-devel
yum install -y openssl openssl-devel
wget https://nginx.org/download/nginx-1.15.8.tar.gz
git clone https://github.com/arut/nginx-rtmp-module.git
tar -xvf nginx-1.15.8.tar.gz
cd nginx-1.15.8
./configure --prefix=/usr/local/nginx  --add-module=../nginx-rtmp-module  --with-http_ssl_module
make
make install

cat >> /usr/local/nginx/conf/nginx.conf <<END
rtmp {      
	server {   
	    listen 1935;
	    chunk_size 4000;     
	    application hls {
		live on;     
	    }   
	}   
} 
END

cd /usr/local/nginx/sbin
./nginx



systemctl restart firewalld.service
systemctl enable firewalld.service
firewall-cmd --set-default-zone=public
firewall-cmd --add-port=22/tcp --permanent
firewall-cmd --add-port=1935/tcp --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

