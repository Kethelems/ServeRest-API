*** Settings ***
Documentation    Testes automatizados para endpoints de Login da API ServeRest
Resource         ../keywords/login_keywords.robot
Resource         ../keywords/usuarios_keywords.robot
Suite Setup      Setup API Session
Test Tags        login    api    smoke

*** Test Cases ***
TC026 - Login Com Credenciais Validas
    [Documentation]    Verifica se é possível fazer login com credenciais válidas
    [Tags]    login    post    positivo    high    smoke    regression
    
    # Criar usuário para teste
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Fazer login
    ${login_data}=    Generate Login Data    ${user_data['email']}    ${user_data['password']}
    ${login_response}=    Fazer Login Via API    ${login_data}
    ${token}=         Validar Login Sucesso    ${login_response}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC027 - Validar Estrutura Do Token
    [Documentation]    Verifica se o token retornado possui estrutura JWT válida
    [Tags]    login    post    positivo    medium    token    json    regression
    
    # Criar usuário para teste
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Fazer login e validar token
    ${login_data}=    Generate Login Data    ${user_data['email']}    ${user_data['password']}
    ${login_response}=    Fazer Login Via API    ${login_data}
    ${token}=         Extract Token From Response    ${login_response}
    Validar Estrutura Token    ${token}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC028 - Validar Tempo Expiracao Token
    [Documentation]    Verifica se o token possui informações de expiração
    [Tags]    login    post    positivo    low    token    regression
    
    # Criar usuário para teste
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Fazer login
    ${login_data}=    Generate Login Data    ${user_data['email']}    ${user_data['password']}
    ${login_response}=    Fazer Login Via API    ${login_data}
    Validate Response Status    ${login_response}    200
    
    # Validar que token não está vazio
    ${token}=    Extract Token From Response    ${login_response}
    Should Not Be Empty    ${token}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC029 - Login Com Usuario Administrador
    [Documentation]    Verifica se é possível fazer login com usuário administrador
    [Tags]    login    post    positivo    high    admin    smoke
    
    # Criar usuário admin para teste
    ${user_data}=    Generate Test Data    admin_flag=${ADMIN_TRUE}
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Fazer login
    ${login_data}=    Generate Login Data    ${user_data['email']}    ${user_data['password']}
    ${login_response}=    Fazer Login Via API    ${login_data}
    ${token}=         Validar Login Sucesso    ${login_response}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC030 - Login Com Email Inexistente
    [Documentation]    Verifica erro ao tentar login com email inexistente
    [Tags]    login    post    negativo    medium    error    regression
    
    ${login_data}=    Generate Login Data    email=inexistente@teste.com    password=senha123
    ${response}=      Fazer Login Via API    ${login_data}
    Validar Login Erro    ${response}    Email e/ou senha inválidos

TC031 - Login Com Senha Incorreta
    [Documentation]    Verifica erro ao tentar login com senha incorreta
    [Tags]    login    post    negativo    medium    error    regression
    
    # Criar usuário para teste
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Tentar login com senha errada
    ${login_data}=    Generate Login Data    ${user_data['email']}    senha_errada
    ${login_response}=    Fazer Login Via API    ${login_data}
    Validar Login Erro    ${login_response}    Email e/ou senha inválidos
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC032 - Login Com Email Em Branco
    [Documentation]    Verifica erro ao tentar login com email em branco
    [Tags]    login    post    negativo    medium    validation    regression
    
    ${login_data}=    Generate Login Data    email=${EMPTY}    password=senha123
    ${response}=      Fazer Login Via API    ${login_data}
    Validate Response Status    ${response}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    email

TC033 - Login Com Password Em Branco
    [Documentation]    Verifica erro ao tentar login com password em branco
    [Tags]    login    post    negativo    medium    validation    regression
    
    ${login_data}=    Generate Login Data    email=teste@teste.com    password=${EMPTY}
    ${response}=      Fazer Login Via API    ${login_data}
    Validate Response Status    ${response}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    password