*** Variables ***
# IMPORTANTE: Para trocar ambiente, edite config/environments.robot

# Configurações da API ServeRest
${BASE_URL}                 https://serverest.dev
${TIMEOUT}                  10

# Headers padrão
&{DEFAULT_HEADERS}          Content-Type=application/json

# Dados de teste
${VALID_USER_NAME}          Teste Automacao
${VALID_PASSWORD}           senha123
${ADMIN_TRUE}               true
${ADMIN_FALSE}              false

# Mensagens esperadas
${MSG_CADASTRO_SUCESSO}     Cadastro realizado com sucesso
${MSG_LOGIN_SUCESSO}        Login realizado com sucesso
${MSG_EMAIL_EXISTENTE}      Este email já está sendo usado
${MSG_TOKEN_INVALIDO}       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais