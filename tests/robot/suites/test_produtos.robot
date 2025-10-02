*** Settings ***
Documentation    Testes automatizados para endpoints de Produtos da API ServeRest
Resource         ../keywords/produtos_keywords.robot
Resource         ../keywords/login_keywords.robot
Resource         ../keywords/usuarios_keywords.robot
Suite Setup      Setup API Session
Test Tags        produtos    api    smoke

*** Test Cases ***
TC038 - Listar Produtos Sem Autenticacao
    [Documentation]    Verifica se é possível listar produtos sem autenticação
    [Tags]    listagem    positivo    low
    
    ${response}=    Listar Produtos Via API
    Validate Response Status    ${response}    200
    Validate JSON Response    ${response}
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    produtos
    Should Contain    ${json_response}    quantidade

TC039 - Criar Produto Com Token Valido
    [Documentation]    Verifica se é possível criar produto com token válido
    [Tags]    criacao    positivo    high
    
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Criar produto
    ${produto_data}=    Generate Produto Data
    ${response}=        Criar Produto Via API    ${produto_data}    ${token}
    ${produto_id}=      Validar Criacao Produto Sucesso    ${response}
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC040 - Listar Produtos Por Query Parameters
    [Documentation]    Verifica se é possível listar produtos usando query parameters
    [Tags]    listagem    query    positivo    medium
    
    ${response}=    Listar Produtos Via API
    Validate Response Status    ${response}    200
    Validate JSON Response    ${response}

TC041 - Buscar Produto Por ID Valido
    [Documentation]    Verifica se é possível buscar produto por ID válido
    [Tags]    busca    positivo    medium
    
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Criar produto
    ${produto_data}=    Generate Produto Data
    ${response}=        Criar Produto Via API    ${produto_data}    ${token}
    ${produto_id}=      Validar Criacao Produto Sucesso    ${response}
    
    # Buscar produto
    ${get_response}=    Buscar Produto Por ID Via API    ${produto_id}
    Validate Response Status    ${get_response}    200
    Should Be Equal    ${get_response.json()['_id']}    ${produto_id}
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC042 - Atualizar Produto Existente
    [Documentation]    Verifica se é possível atualizar produto existente
    [Tags]    atualizacao    positivo    medium
    
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Criar produto
    ${produto_data}=    Generate Produto Data
    ${response}=        Criar Produto Via API    ${produto_data}    ${token}
    ${produto_id}=      Validar Criacao Produto Sucesso    ${response}
    
    # Atualizar produto
    ${updated_data}=    Generate Produto Data    nome=Produto Atualizado
    ${update_response}=    Atualizar Produto Via API    ${produto_id}    ${updated_data}    ${token}
    Validate Response Status    ${update_response}    200
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC043 - Criar Produto Via PUT Com ID Inexistente
    [Documentation]    Verifica se é possível criar produto via PUT com ID inexistente
    [Tags]    criacao    put    positivo    medium
    
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Tentar criar via PUT com ID inexistente
    ${produto_data}=    Generate Produto Data
    ${fake_id}=         Set Variable    507f1f77bcf86cd799439011
    ${response}=        Atualizar Produto Via API    ${fake_id}    ${produto_data}    ${token}
    Validate Response Status    ${response}    400
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC044 - Deletar Produto Sem Dependencias
    [Documentation]    Verifica se é possível deletar produto sem dependências
    [Tags]    delecao    positivo    medium
    
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Criar produto
    ${produto_data}=    Generate Produto Data
    ${response}=        Criar Produto Via API    ${produto_data}    ${token}
    ${produto_id}=      Validar Criacao Produto Sucesso    ${response}
    
    # Deletar produto
    ${delete_response}=    Deletar Produto Via API    ${produto_id}    ${token}
    Validate Response Status    ${delete_response}    200
    Should Contain    ${delete_response.json()['message']}    Registro excluído com sucesso
    
    # Cleanup
    Deletar Usuario Via API    ${user_id}

TC045 - Validar Estrutura Resposta Produto
    [Documentation]    Verifica se a resposta possui estrutura JSON esperada para produto
    [Tags]    estrutura    positivo    low
    
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Criar produto
    ${produto_data}=    Generate Produto Data
    ${response}=        Criar Produto Via API    ${produto_data}    ${token}
    ${produto_id}=      Validar Criacao Produto Sucesso    ${response}
    
    # Buscar produto e validar estrutura
    ${get_response}=    Buscar Produto Por ID Via API    ${produto_id}
    ${json_data}=       Set Variable    ${get_response.json()}
    
    Should Contain    ${json_data}    _id
    Should Contain    ${json_data}    nome
    Should Contain    ${json_data}    preco
    Should Contain    ${json_data}    descricao
    Should Contain    ${json_data}    quantidade
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC046 - Criar Produto Sem Token
    [Documentation]    Verifica erro ao tentar criar produto sem token
    [Tags]    criacao    negativo    error    high
    
    ${produto_data}=    Generate Produto Data
    ${response}=        Criar Produto Via API    ${produto_data}
    Validar Produto Sem Token    ${response}

TC049 - Criar Produto Com Nome Duplicado
    [Documentation]    Verifica erro ao tentar criar produto com nome duplicado
    [Tags]    criacao    negativo    validacao    medium
    
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Criar primeiro produto
    ${produto_data}=    Generate Produto Data    nome=Produto Duplicado
    ${response1}=       Criar Produto Via API    ${produto_data}    ${token}
    ${produto_id}=      Validar Criacao Produto Sucesso    ${response1}
    
    # Tentar criar segundo produto com mesmo nome
    ${response2}=    Criar Produto Via API    ${produto_data}    ${token}
    Validate Response Status    ${response2}    400
    Should Contain    ${response2.json()['message']}    Já existe produto com esse nome
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}