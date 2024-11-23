FROM ubuntu:24.04

# Systempackete installieren
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    zsh \
    git \
    curl \
    wget \
    scdaemon \
    gnupg2 \
    gnupg-agent \
    pinentry-curses \
    vim \
    usbutils \
    openssh-server \
    dirmngr \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get upgrade -y

# Oh My Zsh installieren
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Powerlevel10k installieren
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Powerlevel10k als Standard-Theme setzen
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
RUN echo "gpgconf --kill gpg-agent > /dev/null" >> ~/.zshrc && \
    echo 'eval "$(gpg-agent --sh --daemon)"' >> ~/.zshrc 

COPY p10k.zsh /root/.p10k.zsh
COPY run.sh /root/run.sh
RUN chmod 777 /root/run.sh
RUN echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
RUN echo "syntax on" > ~/.vimrc && \
    echo "set mouse-=a" >> ~/.vimrc

RUN mkdir /var/run/sshd
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# GPG-Agent Konfiguration
RUN mkdir -p ~/.gnupg && \
    echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf && \
    echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf && \
    chmod 700 ~/.gnupg/

RUN usermod -s /bin/zsh root

# Shell auf zsh setzen
SHELL ["/bin/zsh", "-c"]

# Container starten
CMD [ "/root/run.sh"]

