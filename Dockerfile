FROM oraclelinux:7-slim

#MAY-2018, Installs puppet 5 and leaves it ready as a base for puppet standalone work

RUN echo "Install Puppet and Librarian..." && \
    yum -y update && yum -y upgrade && \
    yum -y install hostname.x86_64 wget git binutils.x86_64 unzip.x86_64 net-tools openssl && \
    wget -nv --output-document=/tmp/puppet5-release-el-7.noarch.rpm https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm  && \
    yum -y localinstall /tmp/puppet5-release-el-7.noarch.rpm  && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    yum -y install puppet tar && \
    /opt/puppetlabs/puppet/bin/gem install librarian-puppet && \
    /opt/puppetlabs/puppet/bin/gem install hiera-eyaml && \
    /opt/puppetlabs/puppet/bin/gem install puppet-lint && \
    yum clean all && rm -rf /var/cache/yum

ENV PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin
ENV LIBRARIAN_PUPPET_PATH=code/modules  
WORKDIR /etc/puppetlabs/

#This part forward is to setup the process. 
#Everything new in the /etc/puppetlabs folder should come from your project.
#Inserting a Puppetfile to kick off the librarian and show how it's done.
COPY Puppetfile /etc/puppetlabs/
RUN librarian-puppet install --verbose && librarian-puppet show
