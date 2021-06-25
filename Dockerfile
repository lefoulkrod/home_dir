FROM ubuntu:latest

# install packages
RUN apt update && \
    apt -y install zsh git curl openssh-client vim gnupg zip netcat make

# install kubectl
RUN curl -LO https://dl.k8s.io/release/v1.21.1/bin/linux/amd64/kubectl && \
    curl -LO "https://dl.k8s.io/v1.21.1/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c && \
    chmod 0755 kubectl && \
    mv kubectl /usr/local/bin/ && \
    rm kubectl.sha256

# install k9s
RUN curl -LO https://github.com/derailed/k9s/releases/download/v0.24.10/k9s_v0.24.10_Linux_x86_64.tar.gz && \
    curl -LO https://github.com/derailed/k9s/releases/download/v0.24.10/checksums.txt && \
    awk '/k9s_v0.24.10_Linux_x86_64.tar.gz/ {print}' checksums.txt | sha256sum -c  && \
    tar -xvf k9s_v0.24.10_Linux_x86_64.tar.gz k9s && \
    chmod +x k9s && \
    mv k9s /usr/local/bin/

# install tkn
RUN curl -LO https://github.com/tektoncd/cli/releases/download/v0.19.0/tkn_0.19.0_Linux_x86_64.tar.gz && \
    curl -LO https://github.com/tektoncd/cli/releases/download/v0.19.0/checksums.txt && \
    awk '/tkn_0.19.0_Linux_x86_64.tar.gz/ {print}' checksums.txt | sha256sum -c  && \
    tar -xvf tkn_0.19.0_Linux_x86_64.tar.gz tkn && \
    chmod +x tkn && \
    mv tkn /usr/local/bin/

RUN rm checksums.txt *.tar.gz

# install aws cli
COPY aws-signing-key.pub /tmp/
RUN gpg --import /tmp/aws-signing-key.pub
RUN curl -LO https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.12.zip && \
    curl -LO https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.12.zip.sig && \
    gpg --verify awscli-exe-linux-x86_64-2.2.12.zip.sig awscli-exe-linux-x86_64-2.2.12.zip && \
    unzip awscli-exe-linux-x86_64-2.2.12.zip && \
    ./aws/install

# install oh-my-zsh
COPY install_zsh.sh /tmp/
RUN sh /tmp/install_zsh.sh
COPY .zshrc /root/ 
COPY aliases.zsh /root/.oh-my-zsh/custom/

# add configs
COPY .gitconfig /root/

# "install" the docker cli binary
COPY --from=docker:20.10.7 /usr/local/bin/docker /usr/local/bin/

CMD [ "/bin/zsh" ]
