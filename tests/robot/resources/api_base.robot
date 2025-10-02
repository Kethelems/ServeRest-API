*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Library    DateTime
Resource   ../variables/api_config.robot

*** Keywords ***
Setup API Session
    Create Session    serverest    ${BASE_URL}    timeout=${TIMEOUT}

Generate Unique Email
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S%f
    ${unique_email}=    Set Variable    qa+${timestamp}@example.com
    RETURN    ${unique_email}

Generate Test Data
    [Arguments]    &{kwargs}
    ${admin_flag}=    Get From Dictionary    ${kwargs}    admin_flag    ${ADMIN_TRUE}
    ${nome}=          Get From Dictionary    ${kwargs}    nome         ${VALID_USER_NAME}
    ${email}=         Get From Dictionary    ${kwargs}    email        ${EMPTY}
    ${password}=      Get From Dictionary    ${kwargs}    password     ${VALID_PASSWORD}
    
    ${unique_email}=    Run Keyword If    '${email}' == '${EMPTY}'    Generate Unique Email
    ...    ELSE    Set Variable    ${email}
    
    ${test_data}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${unique_email}
    ...    password=${password}
    ...    administrador=${admin_flag}
    RETURN    ${test_data}

Validate Response Status
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status}

Validate JSON Response
    [Arguments]    ${response}
    Should Be Equal    ${response.headers['Content-Type']}    application/json; charset=utf-8

Extract User ID From Response
    [Arguments]    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    _id
    RETURN    ${json_response['_id']}

DELETE Without Exception
    [Arguments]    ${endpoint}    ${headers}=${DEFAULT_HEADERS}
    ${response}=    DELETE On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    RETURN    ${response}

POST Without Exception
    [Arguments]    ${endpoint}    ${data}=${NONE}    ${headers}=${DEFAULT_HEADERS}
    ${response}=    POST On Session    serverest    ${endpoint}    json=${data}    headers=${headers}    expected_status=any
    RETURN    ${response}

GET Without Exception
    [Arguments]    ${endpoint}
    ${response}=    GET On Session    serverest    ${endpoint}    expected_status=any
    RETURN    ${response}