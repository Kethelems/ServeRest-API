#!/bin/bash
# =============================================================================
# SCRIPT PARA CONFIGURAR SERVEREST NA EC2
# =============================================================================

echo "🚀 Configurando ServeRest na EC2..."

# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verificar instalação
echo "Node.js version: $(node --version)"
echo "NPM version: $(npm --version)"

# Clonar ServeRest
git clone https://github.com/ServeRest/ServeRest.git
cd ServeRest

# Instalar dependências
npm install

# Configurar para aceitar conexões externas
echo "🔧 Configurando para aceitar conexões externas..."

# Criar arquivo de configuração
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'serverest',
    script: './src/ServeRest.js',
    env: {
      NODE_ENV: 'production',
      PORT: 3000,
      HOST: '0.0.0.0'
    }
  }]
}
EOF

# Instalar PM2 para gerenciar processo
sudo npm install -g pm2

# Iniciar ServeRest
pm2 start ecosystem.config.js

# Configurar PM2 para iniciar no boot
pm2 startup
pm2 save

# Configurar firewall
sudo ufw allow 3000
sudo ufw allow ssh
sudo ufw --force enable

echo "✅ ServeRest configurado com sucesso!"
echo "📡 API disponível em: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
echo "📊 Documentação: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"