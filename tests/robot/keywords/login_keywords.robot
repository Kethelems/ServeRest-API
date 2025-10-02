*** Settings ***
Resource    ../resources/api_base.robot

*** Keywords ***
Fazer Login Via API
    [Arguments]    ${login_data}
    ${response}=    POST Without Exception    /login    ${login_data}
    RETURN    ${response}

Validar Login Sucesso
    [Arguments]    ${response}
    Validate Response Status    ${response}    200
    Validate JSON Response    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['message']}    ${MSG_LOGIN_SUCESSO}
    Should Contain    ${json_response}    authorization
    RETURN    ${json_response['authorization']}

Validar Login Erro
    [Arguments]    ${response}    ${expected_message}
    Validate Response Status    ${response}    401
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response['message']}    ${expected_message}

Generate Login Data
    [Arguments]    ${email}=${EMPTY}    ${password}=${EMPTY}
    ${login_data}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}
    RETURN    ${login_data}

Validar Estrutura Token
    [Arguments]    ${token}
    Should Not Be Empty    ${token}
    Should Start With    ${token}    Bearer
    ${token_parts}=    Split String    ${token}    .
    Length Should Be    ${token_parts}    3    Token JWT deve ter 3 partes

Extract Token From Response
    [Arguments]    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    RETURN    ${json_response['authorization']}