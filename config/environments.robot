*** Variables ***
# =============================================================================
# CONFIGURAÇÕES DE AMBIENTE
# =============================================================================

# Ambiente LOCAL (para desenvolvimento)
${LOCAL_URL}           http://localhost:3000
${LOCAL_TIMEOUT}       5

# Ambiente EC2 (para challenge extra)
${EC2_URL}             http://SEU-IP-EC2:3000
${EC2_TIMEOUT}         10

# Ambiente PÚBLICO (atual)
${PUBLIC_URL}          https://serverest.dev
${PUBLIC_TIMEOUT}      15

# =============================================================================
# CONFIGURAÇÃO ATIVA (altere aqui para trocar ambiente)
# =============================================================================
${BASE_URL}            ${PUBLIC_URL}
${TIMEOUT}             ${PUBLIC_TIMEOUT}

# Headers padrão
&{DEFAULT_HEADERS}     Content-Type=application/json

# Dados de teste
${VALID_USER_NAME}     Teste Automacao
${VALID_PASSWORD}      senha123
${ADMIN_TRUE}          true
${ADMIN_FALSE}         false

# Mensagens esperadas
${MSG_CADASTRO_SUCESSO}    Cadastro realizado com sucesso
${MSG_LOGIN_SUCESSO}       Login realizado com sucesso
${MSG_EMAIL_EXISTENTE}     Este email já está sendo usado
${MSG_TOKEN_INVALIDO}      Token de acesso ausente, inválido, expirado ou usuário do token não existe mais