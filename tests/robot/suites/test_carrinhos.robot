*** Settings ***
Documentation    Testes automatizados para endpoints de Carrinhos da API ServeRest
Resource         ../keywords/carrinhos_keywords.robot
Resource         ../keywords/produtos_keywords.robot
Resource         ../keywords/login_keywords.robot
Resource         ../keywords/usuarios_keywords.robot
Suite Setup      Setup API Session
Test Tags        carrinhos    api    smoke

*** Test Cases ***
TC058 - Listar Carrinhos Cadastrados
    [Documentation]    Verifica se é possível listar carrinhos cadastrados
    [Tags]    listagem    positivo    low
    
    ${response}=    Listar Carrinhos Via API
    Validate Response Status    ${response}    200
    Validate JSON Response    ${response}
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    carrinhos
    Should Contain    ${json_response}    quantidade

TC059 - Criar Carrinho Com Produtos Validos
    [Documentation]    Verifica se é possível criar carrinho com produtos válidos
    [Tags]    criacao    positivo    high
    
    # Criar usuário, produto e obter token
    ${token}    ${user_id}    ${produto_id}=    Create User Product And Token
    
    # Criar carrinho
    ${produto_carrinho}=    Generate Produto Para Carrinho    ${produto_id}    2
    ${produtos}=            Create List    ${produto_carrinho}
    ${carrinho_data}=       Generate Carrinho Data    ${produtos}
    ${response}=            Criar Carrinho Via API    ${carrinho_data}    ${token}
    ${carrinho_id}=         Validar Criacao Carrinho Sucesso    ${response}
    
    # Cleanup
    Excluir Carrinho Via API    ${token}    cancelar-compra
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC060 - Buscar Carrinho Por ID
    [Documentation]    Verifica se é possível buscar carrinho por ID
    [Tags]    busca    positivo    medium
    
    # Criar usuário, produto e obter token
    ${token}    ${user_id}    ${produto_id}=    Create User Product And Token
    
    # Criar carrinho
    ${produto_carrinho}=    Generate Produto Para Carrinho    ${produto_id}    1
    ${produtos}=            Create List    ${produto_carrinho}
    ${carrinho_data}=       Generate Carrinho Data    ${produtos}
    ${response}=            Criar Carrinho Via API    ${carrinho_data}    ${token}
    ${carrinho_id}=         Validar Criacao Carrinho Sucesso    ${response}
    
    # Buscar carrinho
    ${get_response}=    Buscar Carrinho Por ID Via API    ${carrinho_id}
    Validate Response Status    ${get_response}    200
    Should Be Equal    ${get_response.json()['_id']}    ${carrinho_id}
    
    # Cleanup
    Excluir Carrinho Via API    ${token}    cancelar-compra
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC061 - Excluir Carrinho
    [Documentation]    Verifica se é possível excluir carrinho
    [Tags]    exclusao    positivo    medium
    
    # Criar usuário, produto e obter token
    ${token}    ${user_id}    ${produto_id}=    Create User Product And Token
    
    # Criar carrinho
    ${produto_carrinho}=    Generate Produto Para Carrinho    ${produto_id}    1
    ${produtos}=            Create List    ${produto_carrinho}
    ${carrinho_data}=       Generate Carrinho Data    ${produtos}
    ${response}=            Criar Carrinho Via API    ${carrinho_data}    ${token}
    ${carrinho_id}=         Validar Criacao Carrinho Sucesso    ${response}
    
    # Excluir carrinho
    ${delete_response}=    Excluir Carrinho Via API    ${token}    cancelar-compra
    Validate Response Status    ${delete_response}    200
    Should Contain    ${delete_response.json()['message']}    Registro excluído com sucesso
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC062 - Excluir Carrinho E Retornar Produtos Ao Estoque
    [Documentation]    Verifica se produtos retornam ao estoque ao cancelar compra
    [Tags]    exclusao    estoque    positivo    medium
    
    # Criar usuário, produto e obter token
    ${token}    ${user_id}    ${produto_id}=    Create User Product And Token
    
    # Verificar estoque inicial
    ${produto_inicial}=    Buscar Produto Por ID Via API    ${produto_id}
    ${estoque_inicial}=    Set Variable    ${produto_inicial.json()['quantidade']}
    
    # Criar carrinho
    ${produto_carrinho}=    Generate Produto Para Carrinho    ${produto_id}    2
    ${produtos}=            Create List    ${produto_carrinho}
    ${carrinho_data}=       Generate Carrinho Data    ${produtos}
    ${response}=            Criar Carrinho Via API    ${carrinho_data}    ${token}
    ${carrinho_id}=         Validar Criacao Carrinho Sucesso    ${response}
    
    # Cancelar compra (retorna estoque)
    ${delete_response}=    Excluir Carrinho Via API    ${token}    cancelar-compra
    Validate Response Status    ${delete_response}    200
    Should Contain    ${delete_response.json()['message']}    Registro excluído com sucesso. Estoque dos produtos reabastecido
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC076 - Concluir Compra
    [Documentation]    Verifica se é possível concluir compra
    [Tags]    compra    positivo    high
    
    # Criar usuário, produto e obter token
    ${token}    ${user_id}    ${produto_id}=    Create User Product And Token
    
    # Criar carrinho
    ${produto_carrinho}=    Generate Produto Para Carrinho    ${produto_id}    1
    ${produtos}=            Create List    ${produto_carrinho}
    ${carrinho_data}=       Generate Carrinho Data    ${produtos}
    ${response}=            Criar Carrinho Via API    ${carrinho_data}    ${token}
    ${carrinho_id}=         Validar Criacao Carrinho Sucesso    ${response}
    
    # Concluir compra
    ${delete_response}=    Excluir Carrinho Via API    ${token}    concluir-compra
    Validate Response Status    ${delete_response}    200
    Should Contain    ${delete_response.json()['message']}    Registro excluído com sucesso
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}

TC077 - Cancelar Compra
    [Documentation]    Verifica se é possível cancelar compra
    [Tags]    compra    cancelar    positivo    medium
    
    # Criar usuário, produto e obter token
    ${token}    ${user_id}    ${produto_id}=    Create User Product And Token
    
    # Criar carrinho
    ${produto_carrinho}=    Generate Produto Para Carrinho    ${produto_id}    1
    ${produtos}=            Create List    ${produto_carrinho}
    ${carrinho_data}=       Generate Carrinho Data    ${produtos}
    ${response}=            Criar Carrinho Via API    ${carrinho_data}    ${token}
    ${carrinho_id}=         Validar Criacao Carrinho Sucesso    ${response}
    
    # Cancelar compra
    ${delete_response}=    Excluir Carrinho Via API    ${token}    cancelar-compra
    Validate Response Status    ${delete_response}    200
    Should Contain    ${delete_response.json()['message']}    Estoque dos produtos reabastecido
    
    # Cleanup
    Deletar Produto Via API    ${produto_id}    ${token}
    Deletar Usuario Via API    ${user_id}