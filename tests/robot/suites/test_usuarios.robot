*** Settings ***
Documentation    Testes automatizados para endpoints de Usuários da API ServeRest
Resource         ../keywords/usuarios_keywords.robot
Suite Setup      Setup API Session
Test Tags        usuarios    api    smoke

*** Test Cases ***
TC001 - Criar Usuario Valido Com Todos Os Campos
    [Documentation]    Verifica se é possível criar um usuário válido com todos os campos obrigatórios
    [Tags]    criacao    positivo    high
    
    ${user_data}=    Generate Test Data    admin_flag=${ADMIN_TRUE}
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC007 - Criar Usuario Administrador
    [Documentation]    Verifica se é possível criar um usuário com perfil administrador
    [Tags]    criacao    admin    positivo    medium
    
    ${user_data}=    Generate Test Data    admin_flag=${ADMIN_TRUE}
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Validar que o usuário foi criado como admin
    ${get_response}=    Buscar Usuario Por ID Via API    ${user_id}
    Should Be Equal    ${get_response.json()['administrador']}    ${ADMIN_TRUE}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC008 - Criar Usuario Nao Administrador
    [Documentation]    Verifica se é possível criar um usuário com perfil não-administrador
    [Tags]    criacao    user    positivo    medium
    
    ${user_data}=    Generate Test Data    admin_flag=${ADMIN_FALSE}
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Validar que o usuário foi criado como não-admin
    ${get_response}=    Buscar Usuario Por ID Via API    ${user_id}
    Should Be Equal    ${get_response.json()['administrador']}    ${ADMIN_FALSE}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC011 - Criar Usuario Com Email Ja Existente
    [Documentation]    Verifica se o sistema impede a criação de usuário com email já cadastrado
    [Tags]    criacao    negativo    validacao    high
    
    # Criar primeiro usuário
    ${user_data}=    Generate Test Data
    ${response1}=    Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response1}
    
    # Tentar criar segundo usuário com mesmo email
    ${response2}=    Criar Usuario Via API    ${user_data}
    Validar Email Ja Existe    ${response2}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC002 - Listar Todos Os Usuarios
    [Documentation]    Verifica se é possível listar todos os usuários cadastrados
    [Tags]    listagem    positivo    low
    
    ${response}=    Listar Usuarios Via API
    Validate Response Status    ${response}    200
    Validate JSON Response    ${response}
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    usuarios
    Should Contain    ${json_response}    quantidade

TC003 - Buscar Usuario Por ID
    [Documentation]    Verifica se é possível buscar um usuário específico pelo ID
    [Tags]    busca    positivo    medium
    
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    ${get_response}=    Buscar Usuario Por ID Via API    ${user_id}
    Validate Response Status    ${get_response}    200
    Should Be Equal    ${get_response.json()['_id']}    ${user_id}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC004 - Atualizar Usuario Valido
    [Documentation]    Verifica se é possível atualizar dados de um usuário existente
    [Tags]    atualizacao    positivo    medium
    
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    ${updated_data}=    Generate Test Data    nome=Usuario Atualizado
    ${update_response}=    Atualizar Usuario Via API    ${user_id}    ${updated_data}
    Validate Response Status    ${update_response}    200
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC006 - Deletar Usuario Valido
    [Documentation]    Verifica se é possível deletar um usuário existente
    [Tags]    delecao    positivo    medium
    
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    ${delete_response}=    Deletar Usuario Via API    ${user_id}
    Validate Response Status    ${delete_response}    200
    Should Contain    ${delete_response.json()['message']}    Registro excluído com sucesso

TC009 - Validar Campos Obrigatorios
    [Documentation]    Verifica se o sistema valida campos obrigatórios na criação de usuário
    [Tags]    validacao    negativo    high
    
    ${empty_data}=    Create Dictionary
    ${response}=      Criar Usuario Via API    ${empty_data}
    Validate Response Status    ${response}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    nome

TC010 - Validar Estrutura JSON
    [Documentation]    Verifica se a resposta da API possui a estrutura JSON esperada
    [Tags]    estrutura    positivo    low
    
    ${user_data}=    Generate Test Data
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    ${get_response}=    Buscar Usuario Por ID Via API    ${user_id}
    ${json_data}=       Set Variable    ${get_response.json()}
    
    Should Contain    ${json_data}    _id
    Should Contain    ${json_data}    nome
    Should Contain    ${json_data}    email
    Should Contain    ${json_data}    administrador
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC023 - Nome Com Caracteres Especiais
    [Documentation]    Verifica se é possível criar usuário com caracteres especiais no nome
    [Tags]    validacao    caracteres    medium
    
    ${user_data}=    Generate Test Data    nome=João da Silva & Cia. Ltda.
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC024 - Nome Com Emojis
    [Documentation]    Verifica se é possível criar usuário com emojis no nome
    [Tags]    validacao    emojis    low
    
    ${user_data}=    Generate Test Data    nome=Usuario 😀 Teste 🚀
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC025 - Senha Limite Caracteres - BUG CONHECIDO
    [Documentation]    BUG: API aceita senhas < 5 e > 10 chars quando deveria rejeitar (TC015/TC016 do relatório)
    [Tags]    validacao    senha    medium    bug_conhecido
    
    # BUG: Teste com 4 caracteres (deveria dar erro 400, mas aceita 201)
    ${user_data_bug1}=    Generate Test Data    password=1234
    ${response_bug1}=     Criar Usuario Via API    ${user_data_bug1}
    Validate Response Status    ${response_bug1}    201    # BUG: Aceita quando deveria rejeitar
    ${user_id_bug1}=      Extract User ID From Response    ${response_bug1}
    Log    BUG CONFIRMADO: Senha < 5 chars aceita (deveria ser rejeitada)
    
    # BUG: Teste com 11 caracteres (deveria dar erro 400, mas aceita 201)
    ${user_data_bug2}=    Generate Test Data    password=12345678901
    ${response_bug2}=     Criar Usuario Via API    ${user_data_bug2}
    Validate Response Status    ${response_bug2}    201    # BUG: Aceita quando deveria rejeitar
    ${user_id_bug2}=      Extract User ID From Response    ${response_bug2}
    Log    BUG CONFIRMADO: Senha > 10 chars aceita (deveria ser rejeitada)
    
    # Cleanup
    Deletar Usuario Via API    ${user_id_bug1}
    Deletar Usuario Via API    ${user_id_bug2}

TC014 - Email Dominio Invalido
    [Documentation]    Verifica validação de email com domínio inválido
    [Tags]    validacao    email    negativo    medium
    
    ${user_data}=    Generate Test Data    email=usuario@dominio-invalido
    ${response}=     Criar Usuario Via API    ${user_data}
    Validate Response Status    ${response}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    email

TC020 - Buscar Usuario Inexistente
    [Documentation]    Verifica erro ao buscar usuário com ID inexistente
    [Tags]    busca    negativo    error    medium
    
    ${fake_id}=         Set Variable    507f1f77bcf86cd799439011
    ${response}=        Buscar Usuario Por ID Via API    ${fake_id}
    Validate Response Status    ${response}    400
    ${json_response}=   Set Variable    ${response.json()}
    Should Contain      ${json_response}    id