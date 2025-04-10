# Pequi_capacitacao_2025
Repositório criado para a capacitação do pequi mecânico 2025

## Resumo

Obs1: uma vez que não existe maneira viável de se fazer dual boot com ubuntu e uma VM utilizaria muitos recursos no mac, comprometendo o uso do ROS, não instalei o SO-Ubuntu e fiz tudo direto usando docker

Obs 2: esse repositório foi feito com os comandos para macos

## Instruções
1-Docker build com imagem emulada para M1 (imagem do ROS nao é do mesmo tipo de arquitetura dos mac com Apple Silicon):
docker buildx build --platform linux/amd64 -t ros2-turtlesim .

2- Rodar container com turtlesim
IP=$(ipconfig getifaddr en0) && xhost + $IP && docker run -it --user ros --network=host --ipc=host -v ~/ros2_ws:/my_source_code -v /tmp/.X11-unix:/tmp/.X11-unix:rw --env="DISPLAY=${IP}:0" ros2-turtlesim ros2 run turtlesim turtlesim_node

Por que usar esse comadno no mac?

Esse comando específico para macOS começa obtendo o IP da rede (`ipconfig getifaddr en0`) porque o Docker no macOS roda em uma VM, impedindo o contêiner de acessar diretamente o `localhost` do host, e depois libera o acesso gráfico com `xhost + $IP` para o XQuartz (servidor X11 do macOS). Em seguida, executa o contêiner Docker com flags essenciais: `-it` para modo interativo, `--network=host` e `--ipc=host` para permitir comunicação ROS 2, `-v /tmp/.X11-unix` para compartilhar o socket gráfico, e `--env="DISPLAY=${IP}:0"` para redirecionar a saída gráfica para o XQuartz no host. Já no Linux, isso é mais simples, pois o X11 é nativo e o Docker acessa diretamente o `localhost`, usando apenas `DISPLAY=:0`. O macOS exige essas configurações adicionais devido à sua arquitetura diferente e à dependência do XQuartz para aplicações gráficas baseadas em X11

3- Comandos do turtlesim contidos em: https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Introducing-Turtlesim/Introducing-Turtlesim.html