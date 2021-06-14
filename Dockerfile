FROM alpine:3.13.5

RUN apk update && \
    apk add zsh git curl

# install kubectl
RUN curl -LO https://dl.k8s.io/release/v1.21.1/bin/linux/amd64/kubectl && \
    curl -LO "https://dl.k8s.io/v1.21.1/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c && \
    chmod 0755 kubectl && \
    mv kubectl /usr/local/bin/

COPY install_zsh.sh /tmp/
RUN sh /tmp/install_zsh.sh

COPY .zshrc /root/ 
COPY aliases.zsh /root/.oh-my-zsh/custom/
COPY .gitconfig /root/

CMD [ "/bin/zsh" ]