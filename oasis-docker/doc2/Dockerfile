FROM ubuntu:18.04

# This script was copied from https://github.com/oasisprotocol/oasis-core/blob/master/docker/development/Dockerfile

# Package versions.
ARG GO_VERSION=1.15.1
ARG GO_NANCY_VERSION=1.0.0
ARG GO_NANCY_CHECKSUM=13804837a34c07e7a933b0d6f52c5e580b03ccb209e38fc3d6394b791b414c33
ARG GO_PROTOC_VERSION=3.6.1
ARG GO_PROTOC_GEN_GO_VERSION=1.21.0
ARG GOLANGCILINT_VERSION=1.28.2
ARG GOCOVMERGE_VERSION=b5bfa59ec0adc420475f97f89b58045c721d761c
ARG GOFUMPT_VERSION=abc0db2c416aca0f60ea33c23c76665f6e7ba0b6
ARG RUST_NIGHTLY_VERSION=2020-08-29

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get upgrade -qq && apt-get install -qq \
    build-essential git gdb cmake \
    curl wget unzip \
    pkg-config software-properties-common \
    python python-pyelftools \
    # for gitlint
    python-pip \
    # for rust openssl
    libssl-dev libcurl4-openssl-dev \
    # for benchmarks
    python3-prometheus-client \
    # for seccomp Go bindings support
    libseccomp-dev \
    # for bubblewrap
    libcap2 && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/cache/apt/archives/* && \
    # for linting Git commits
    pip install gitlint

ENV HOME="/root"
ENV GOPATH="/go"
ENV PATH="${HOME}/.cargo/bin:/go/bin:/usr/local/go/bin:${PATH}"

# Install protobuf (apt system v3.0 fails to compile our protos).
RUN wget https://github.com/google/protobuf/releases/download/v${GO_PROTOC_VERSION}/protoc-${GO_PROTOC_VERSION}-linux-x86_64.zip && \
    unzip protoc-${GO_PROTOC_VERSION}-linux-x86_64.zip -x readme.txt -d /usr && \
    rm protoc-${GO_PROTOC_VERSION}-linux-x86_64.zip && \
    chmod a+rx /usr/bin/protoc

# Install Rust.
RUN curl "https://sh.rustup.rs" -sfo rustup.sh && \
    sh rustup.sh -y --default-toolchain nightly-${RUST_NIGHTLY_VERSION} && \
    rustup target add x86_64-fortanix-unknown-sgx && \
    rustup component add rustfmt && \
    cargo install --version 0.4.0 fortanix-sgx-tools && \
    cargo install --version 0.8.2 sgxs-tools && \
    cargo install cargo-audit

# Install Go and utilities.
RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz && \
    mkdir -p /go/bin && \
    # Install a specific version of protoc-gen-go.
    GO111MODULE=on go get google.golang.org/protobuf/cmd/protoc-gen-go@v${GO_PROTOC_GEN_GO_VERSION} && \
    # Install golangci-lint.
    curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | bash -s -- -b /tmp/bin v${GOLANGCILINT_VERSION} && \
    mv /tmp/bin/golangci-lint /go/bin && \
    # Install gocovmerge for e2e coverage.
    GO111MODULE=on go get github.com/wadey/gocovmerge@${GOCOVMERGE_VERSION} && \
    # Install nancy for auditing dependencies.
    curl -sfL -o nancy https://github.com/sonatype-nexus-community/nancy/releases/download/v${GO_NANCY_VERSION}/nancy-linux.amd64-v${GO_NANCY_VERSION} && \
    echo "${GO_NANCY_CHECKSUM} nancy" | sha256sum -c && \
    mv nancy /go/bin/nancy && \
    chmod +x /go/bin/nancy && \
    # Install gofumpt for code formatting.
    GO111MODULE=on go get mvdan.cc/gofumpt@${GOFUMPT_VERSION} && \
    GO111MODULE=on go get mvdan.cc/gofumpt/gofumports@${GOFUMPT_VERSION}

# Install bubblewrap (we need version 0.3.3 which is not available for 18.04).
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/b/bubblewrap/bubblewrap_0.3.3-2_amd64.deb && \
    echo '1cf9bdae5cfab75f292fad9ee0ef76a7c55243dbc0515709624b2a9573d19447 bubblewrap_0.3.3-2_amd64.deb' | sha256sum -c && \
    dpkg -i bubblewrap_0.3.3-2_amd64.deb && \
    rm bubblewrap_0.3.3-2_amd64.deb

##############################################################

# Unsafe Non-SGX Environment
ENV OASIS_UNSAFE_SKIP_AVR_VERIFY="1"
ENV OASIS_UNSAFE_SKIP_KM_POLICY="1"

RUN wget https://github.com/oasisprotocol/oasis-core/archive/v20.11.1.zip &&\
    unzip v20.11.1.zip &&\
    cd oasis-core-20.11.1 &&\
    make &&\
    cp go/oasis-net-runner/oasis-net-runner /usr/local/bin/ &&\
    cp go/oasis-node/oasis-node /usr/local/bin/ &&\
    cp go/oasis-remote-signer/oasis-remote-signer /usr/local/bin/

# RUN export OASIS_UNSAFE_SKIP_AVR_VERIFY="1" &&\
#     export OASIS_UNSAFE_KM_POLICY_KEYS="1" &&\
#     export OASIS_UNSAFE_ALLOW_DEBUG_ENCLAVES="1" &&\
#     make

RUN apt-get update && apt-get install -y openssh-server


RUN apt-get update && apt-get -y upgrade &&\
    apt-get install -y apt-utils openssh-server software-properties-common &&\
    apt-get install -y autotools-dev automake curl git wget zip build-essential gcc pkg-config net-tools nano

#RUN apt-get install -y gdb

#RUN mkdir /var/run/sshd
RUN echo 'root:oasispc' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&\
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

#RUN /etc/init.d/ssh start

# Install oasis-core
#RUN wget https://github.com/oasisprotocol/oasis-core/releases/download/v20.10/oasis_core_20.10_linux_amd64.tar.gz &&\
#    tar zxvf oasis_core_20.10_linux_amd64.tar.gz &&\
#    cp oasis_core_20.10_linux_amd64/oasis-* /usr/local/bin/

RUN echo 'export PS1="\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;47m\]\\$\[\e[m\] "' >> /root/.bashrc

# Sometimes the json generated in the process file is barely reading. This small can reformat it.
COPY ./rejq.sh /rejq.sh

RUN apt install -y jq nano 
RUN sh -c "chmod +x rejq.sh" 
RUN echo 'alias rejq=/./rejq.sh' >> /root/.bashrc

ENTRYPOINT service ssh restart && bash
