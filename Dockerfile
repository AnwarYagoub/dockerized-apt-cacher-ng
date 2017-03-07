# Use Ubuntu as base image
FROM	ubuntu

# Decide which directories will be exposed
VOLUME	["/var/cache/apt-cacher-ng","/var/log/apt-cacher-ng"]

# Install apt-cacher-ng
RUN     apt-get update && apt-get install -y apt-cacher-ng curl

# Make apt-cacher-ng CentOS ready
# source: https://www.pitt-pladdy.com/blog/_20150720-132951_0100_Home_Lab_Project_apt-cacher-ng_with_CentOS/
# 1. Download CentOS mirrors list
RUN		curl -s -S https://www.centos.org/download/full-mirrorlist.csv | sed 's/^.*"http:/http:/' | sed 's/".*$//' | grep ^http > /etc/apt-cacher-ng/centos_mirrors
# 2. Download EPEL 7 mirrors list
RUN		curl -s -S https://mirrors.fedoraproject.org/mirrorlist?repo=epel-7\&arch=x86_64\&country=global -o /etc/apt-cacher-ng/epel_mirrors
# 3. Apply configuration changes
RUN		sed -i 's|# Gentoo Archives|# Gentoo Archives\nRemap-centos: file:centos_mirrors /centos # CentOS Linux|' /etc/apt-cacher-ng/acng.conf && echo "VfilePatternEx: ^/\?release=[0-9]+&arch=*" >> /etc/apt-cacher-ng/acng.conf
RUN		sed -i 's/^# PassThroughPattern: .* # this would allow CONNECT to everything/# PassThroughPattern: .* # this would allow CONNECT to everything\nPassThroughPattern: (mirrors\.fedoraproject\.org|dl\.fedoraproject\.org):443/' /etc/apt-cacher-ng/acng.conf

# Expose port 3142
EXPOSE	3142

# Run apt-cacher-ng service
CMD     chmod 777 /var/cache/apt-cacher-ng && chmod 777 /var/log/apt-cacher-ng && /etc/init.d/apt-cacher-ng start && tail -f /var/log/apt-cacher-ng/*
