*** Settings ***
Resource    ../resources/api_base.robot

*** Keywords ***
Criar Usuario Via API
    [Arguments]    ${user_data}
    ${response}=    POST Without Exception    /usuarios    ${user_data}    ${DEFAULT_HEADERS}
    RETURN    ${response}

Listar Usuarios Via API
    ${response}=    GET Without Exception    /usuarios
    RETURN    ${response}

Buscar Usuario Por ID Via API
    [Arguments]    ${user_id}
    ${response}=    GET Without Exception    /usuarios/${user_id}
    RETURN    ${response}

Atualizar Usuario Via API
    [Arguments]    ${user_id}    ${user_data}
    ${response}=    PUT On Session    serverest    /usuarios/${user_id}    json=${user_data}    headers=${DEFAULT_HEADERS}
    RETURN    ${response}

Deletar Usuario Via API
    [Arguments]    ${user_id}
    ${response}=    DELETE On Session    serverest    /usuarios/${user_id}    expected_status=any
    RETURN    ${response}

Validar Criacao Usuario Sucesso
    [Arguments]    ${response}
    Validate Response Status    ${response}    201
    Validate JSON Response    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['message']}    ${MSG_CADASTRO_SUCESSO}
    Should Contain    ${json_response}    _id
    RETURN    ${json_response['_id']}

Validar Email Ja Existe
    [Arguments]    ${response}
    Validate Response Status    ${response}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['message']}    ${MSG_EMAIL_EXISTENTE}