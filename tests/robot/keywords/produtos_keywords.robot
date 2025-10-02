*** Settings ***
Resource    ../resources/api_base.robot

*** Keywords ***
Criar Produto Via API
    [Arguments]    ${produto_data}    ${token}=${EMPTY}
    ${headers}=    Run Keyword If    '${token}' != '${EMPTY}'
    ...    Create Dictionary    Content-Type=application/json    Authorization=${token}
    ...    ELSE    Set Variable    ${DEFAULT_HEADERS}
    ${response}=    POST Without Exception    /produtos    ${produto_data}    ${headers}
    RETURN    ${response}

Listar Produtos Via API
    ${response}=    GET Without Exception    /produtos
    RETURN    ${response}

Buscar Produto Por ID Via API
    [Arguments]    ${produto_id}
    ${response}=    GET Without Exception    /produtos/${produto_id}
    RETURN    ${response}

Atualizar Produto Via API
    [Arguments]    ${produto_id}    ${produto_data}    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${token}
    ${response}=    PUT On Session    serverest    /produtos/${produto_id}    json=${produto_data}    headers=${headers}    expected_status=any
    RETURN    ${response}

Deletar Produto Via API
    [Arguments]    ${produto_id}    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /produtos/${produto_id}    headers=${headers}    expected_status=any
    RETURN    ${response}

Generate Produto Data
    [Arguments]    &{kwargs}
    ${nome}=       Get From Dictionary    ${kwargs}    nome         Produto Teste
    ${preco}=      Get From Dictionary    ${kwargs}    preco        100
    ${descricao}=  Get From Dictionary    ${kwargs}    descricao    Descrição do produto teste
    ${quantidade}=  Get From Dictionary    ${kwargs}    quantidade   10
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S%f
    ${unique_nome}=  Set Variable    ${nome} ${timestamp}
    
    ${produto_data}=    Create Dictionary
    ...    nome=${unique_nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    RETURN    ${produto_data}

Validar Criacao Produto Sucesso
    [Arguments]    ${response}
    Validate Response Status    ${response}    201
    Validate JSON Response    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['message']}    Cadastro realizado com sucesso
    Should Contain    ${json_response}    _id
    RETURN    ${json_response['_id']}

Validar Produto Sem Token
    [Arguments]    ${response}
    Validate Response Status    ${response}    401
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['message']}    ${MSG_TOKEN_INVALIDO}

Create Admin User And Get Token
    ${user_data}=    Generate Test Data    admin_flag=${ADMIN_TRUE}
    ${response}=     Criar Usuario Via API    ${user_data}
    ${user_id}=      Validar Criacao Usuario Sucesso    ${response}
    
    ${login_data}=    Generate Login Data    ${user_data['email']}    ${user_data['password']}
    ${login_response}=    Fazer Login Via API    ${login_data}
    ${token}=         Extract Token From Response    ${login_response}
    
    RETURN    ${token}    ${user_id}