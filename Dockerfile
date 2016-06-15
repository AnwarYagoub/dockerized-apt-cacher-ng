# Use Ubuntu as base image
FROM        ubuntu

# Decide which directories will be exposed
VOLUME      ["/var/cache/apt-cacher-ng","/var/log/apt-cacher-ng"]

# Install apt-cacher-ng
RUN     apt-get update && apt-get install -y apt-cacher-ng

# Make apt-cacher-ng CentOS ready
COPY	centos_mirrors /etc/apt-cacher-ng/centos_mirrors
RUN	sed -i.orig 's|# Gentoo Archives|# Gentoo Archives\nRemap-centos: file:centos_mirrors /centos|' /etc/apt-cacher-ng/acng.conf \
	&& echo "VfilePatternEx: ^/\?release=[0-9]+&arch=*" >> /etc/apt-cacher-ng/acng.conf
# more exact patter (another patten: VfilePatternEx: ^/\?release=7&arch=*&repo=*&infra=*)

# Expose port 3142
EXPOSE      3142

# Run apt-cacher-ng service
CMD     chmod 777 /var/cache/apt-cacher-ng && chmod 777 /var/log/apt-cacher-ng && /etc/init.d/apt-cacher-ng start && tail -f /var/log/apt-cacher-ng/*

