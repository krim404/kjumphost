FROM ubuntu:latest

# Systempackete installieren
RUN apt-get update && apt-get install -y \
    zsh \
    git \
    curl \
    wget \
    pcscd \
    scdaemon \
    gnupg2 \
    gnupg-agent \
    pinentry-curses \
    && rm -rf /var/lib/apt/lists/*

# Oh My Zsh installieren
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Powerlevel10k installieren
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Powerlevel10k als Standard-Theme setzen
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# GPG-Agent Konfiguration
RUN mkdir -p ~/.gnupg && \
    echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf && \
    echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf

# Shell auf zsh setzen
SHELL ["/bin/zsh", "-c"]

# Container mit zsh starten
CMD [ "zsh" ]

