FROM ghcr.io/ansible/creator-ee:v0.21.0

# Install mkdocs-material
RUN pip install mkdocs-material==9.4.9

# Install Go
RUN curl -OL https://go.dev/dl/go1.21.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install Terraform
RUN microdnf install -y yum-utils && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
    microdnf -y install terraform
