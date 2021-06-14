FROM alpine:3.13.5
RUN apk update && apk add zsh git
ADD install_zsh.sh /tmp/install_zsh.sh
RUN sh /tmp/install_zsh.sh
ADD aliases.zsh /root/.oh-my-zsh/custom/
ADD .gitconfig /root/.gitconfig
CMD [ "/bin/zsh" ]