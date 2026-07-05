*** Settings ***
Library           RequestsLibrary
Library           Collections


*** Variables ***
${BASE_URL}       %{BASE_URL}
${EMAIL}          %{TEST_EMAIL}
${PASSWORD}       %{TEST_PASSWORD}


*** Keywords ***
Create Techshop Session
    Create Session    techshop    ${BASE_URL}

Close Techshop Session
    Delete All Sessions

Get Auth Token
    ${body}=    Create Dictionary    email=${EMAIL}    password=${PASSWORD}
    ${response}=    POST On Session    techshop    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response.json()}[token]
