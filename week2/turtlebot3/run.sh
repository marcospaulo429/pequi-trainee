#!/bin/bash

# Verificar se um argumento foi passado
if [ -z "$1" ]; then
    echo "Uso: ./run.sh <nome_da_imagem>"
    exit 1
fi

# Obter IP da interface en0 (MacOS)
IP=$(ipconfig getifaddr en0)
xhost + $IP

# Nome da imagem do Docker
IMAGE_NAME=$1

# Configurações X11 para MacOS
export DISPLAY="${IP}:0"
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Rodar o container com todas as configurações necessárias
docker run -it \
  --rm \
  --name turtlebot3_container \
  --platform linux/amd64 \               # Forçar emulação x86_64
  --network=host \
  --ipc=host \
  --user=root \
  --env="DISPLAY=${IP}:0" \
  --env="QT_X11_NO_MITSHM=1" \
  --env="LIBGL_ALWAYS_SOFTWARE=1" \      # Forçar renderização por software
  --env="GALLIUM_DRIVER=swrast" \        # Driver Mesa para renderização
  --env="XAUTHORITY=$XAUTH" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$XAUTH:$XAUTH" \
  --volume="$HOME/ros2_ws:/my_source_code:rw" \
  --volume="$(pwd)/shared_folder:/root/shared_folder:rw" \
  "$IMAGE_NAME" \
  /bin/bash -c "source /opt/ros/humble/setup.bash && \
               source /root/turtlebot3_ws/install/setup.bash && \
               export TURTLEBOT3_MODEL=waffle && \
               ros2 launch turtlebot3_gazebo empty_world.launch.py"