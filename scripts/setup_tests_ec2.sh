#!/bin/bash
# =============================================================================
# SCRIPT PARA CONFIGURAR TESTES ROBOT FRAMEWORK NA EC2
# =============================================================================

echo "🤖 Configurando Robot Framework na EC2..."

# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Python e pip
sudo apt install -y python3 python3-pip git

# Verificar instalação
echo "Python version: $(python3 --version)"
echo "Pip version: $(pip3 --version)"

# Instalar Robot Framework e dependências
pip3 install robotframework
pip3 install robotframework-requests

# Verificar instalação do Robot Framework
robot --version

# Clonar projeto de testes (substitua pela URL do seu repositório)
echo "📥 Clonando projeto de testes..."
# git clone https://github.com/SEU-USUARIO/ServeRest-API.git
# cd ServeRest-API

echo "🔧 Configuração concluída!"
echo "📋 Para executar os testes:"
echo "   1. Clone seu repositório: git clone <URL-DO-SEU-REPO>"
echo "   2. Entre na pasta: cd ServeRest-API"
echo "   3. Configure o IP da EC2 do ServeRest em config/environments.robot"
echo "   4. Execute: robot --outputdir results tests/robot/"