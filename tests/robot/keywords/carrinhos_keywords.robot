*** Settings ***
Resource    ../resources/api_base.robot
Resource    produtos_keywords.robot
Resource    login_keywords.robot
Resource    usuarios_keywords.robot

*** Keywords ***
Criar Carrinho Via API
    [Arguments]    ${carrinho_data}    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${token}
    ${response}=    POST Without Exception    /carrinhos    ${carrinho_data}    ${headers}
    RETURN    ${response}

Listar Carrinhos Via API
    ${response}=    GET Without Exception    /carrinhos
    RETURN    ${response}

Buscar Carrinho Por ID Via API
    [Arguments]    ${carrinho_id}
    ${response}=    GET Without Exception    /carrinhos/${carrinho_id}
    RETURN    ${response}

Excluir Carrinho Via API
    [Arguments]    ${token}    ${tipo}=concluir-compra
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE Without Exception    /carrinhos/${tipo}    ${headers}
    RETURN    ${response}

Generate Carrinho Data
    [Arguments]    ${produtos}
    ${carrinho_data}=    Create Dictionary    produtos=${produtos}
    RETURN    ${carrinho_data}

Generate Produto Para Carrinho
    [Arguments]    ${produto_id}    ${quantidade}=1
    ${produto}=    Create Dictionary
    ...    idProduto=${produto_id}
    ...    quantidade=${quantidade}
    RETURN    ${produto}

Validar Criacao Carrinho Sucesso
    [Arguments]    ${response}
    Validate Response Status    ${response}    201
    Validate JSON Response    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['message']}    Cadastro realizado com sucesso
    Should Contain    ${json_response}    _id
    RETURN    ${json_response['_id']}

Validar Carrinho Sem Token
    [Arguments]    ${response}
    Validate Response Status    ${response}    401
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['message']}    ${MSG_TOKEN_INVALIDO}

Create User Product And Token
    # Criar usuário admin e obter token
    ${token}    ${user_id}=    Create Admin User And Get Token
    
    # Criar produto
    ${produto_data}=    Generate Produto Data
    ${produto_response}=    Criar Produto Via API    ${produto_data}    ${token}
    ${produto_id}=      Validar Criacao Produto Sucesso    ${produto_response}
    
    RETURN    ${token}    ${user_id}    ${produto_id}