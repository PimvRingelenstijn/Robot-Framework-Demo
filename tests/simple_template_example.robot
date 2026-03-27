*** Settings ***
Library          RequestsLibrary
Test Template    Validate GET Request Status

*** Variables ***
${BASE_URL}      https://jsonplaceholder.typicode.com

*** Test Cases ***
Fetch Existing Post         200    /posts/1
Fetch Non-Existent Post     404    /posts/999
Fetch Invalid ID            404    /posts/abc
Fetch All Posts             200    /posts

*** Keywords ***
Validate GET Request Status
    [Arguments]    ${expected_status}    ${endpoint}
    Create Session    api_session    ${BASE_URL}
    GET On Session    api_session    ${endpoint}    expected_status=${expected_status}