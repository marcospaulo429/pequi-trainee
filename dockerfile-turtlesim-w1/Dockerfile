# Usa a imagem OSRF para ARM64 (se disponível) ou alternativa
FROM osrf/ros:humble-desktop-full

# Instala dependências básicas
RUN apt-get update && apt-get install -y \
    nano \
    vim \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Configura usuário não-root
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /home/$USERNAME/.config \
    && chown $USER_UID:$USER_GID /home/$USERNAME/.config \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Configura o ambiente (certifique-se de ter esses arquivos no seu diretório de build)
COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc
COPY config/ /site_config/

WORKDIR /home/$USERNAME
USER $USERNAME

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]