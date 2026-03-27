*** Settings ***
Documentation    API tests using test templates for efficient test case creation
...              This demonstrates how templates reduce code duplication
Library          RequestsLibrary
Library          Collections

*** Variables ***
${BASE_URL}      https://jsonplaceholder.typicode.com
${ENDPOINTS}     /posts    /comments    /albums    /photos    /todos    /users

*** Keywords ***
Create API Session
    [Documentation]    Create session to API
    Create Session      jsonplaceholder    ${BASE_URL}    verify=True

Verify Endpoint Returns 200
    [Documentation]    Template keyword to test GET endpoint returns 200
    [Arguments]         ${endpoint}
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    ${endpoint}
    Status Should Be    200                ${response}
    Log                 ${endpoint} returned status ${response.status_code}

Verify Single Resource Returns 200
    [Documentation]    Template keyword to test GET for single resource
    [Arguments]         ${endpoint}    ${resource_id}
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    ${endpoint}/${resource_id}
    Status Should Be    200                ${response}
    ${json}=            Set Variable       ${response.json()}
    Should Be Equal As Integers    ${json['id']}    ${resource_id}
    Log                 Retrieved ${endpoint} with ID ${resource_id}

Verify Non-existent Resource Returns 404
    [Documentation]    Template keyword to test 404 for non-existent resource
    [Arguments]         ${endpoint}    ${invalid_id}
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    ${endpoint}/${invalid_id}    expected_status=404
    Status Should Be    404                ${response}
    Log                 Correctly received 404 for ${endpoint}/${invalid_id}

Verify Nested Resource Returns 200
    [Documentation]    Template keyword to test nested endpoints
    [Arguments]         ${parent_endpoint}    ${parent_id}    ${child_endpoint}
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    ${parent_endpoint}/${parent_id}/${child_endpoint}
    Status Should Be    200                ${response}
    Log                 Retrieved ${child_endpoint} for ${parent_endpoint}/${parent_id}

*** Test Cases ***
Test All Main Endpoints Return 200    [Template]    Verify Endpoint Returns 200
    [Documentation]    Template test verifying all main endpoints return 200
    /posts
    /comments
    /albums
    /photos
    /todos
    /users

Test Single Resource Retrieval    [Template]    Verify Single Resource Returns 200
    [Documentation]    Template test for retrieving single resources with valid IDs
    /posts    1
    /comments    1
    /albums    1
    /photos    1
    /todos    1
    /users    1

Test Non-existent Resources    [Template]    Verify Non-existent Resource Returns 404
    [Documentation]    Template test for invalid resource IDs
    /posts    99999
    /comments    99999
    /albums    99999
    /photos    99999
    /todos    99999
    /users    99999

Test Nested Resources    [Template]    Verify Nested Resource Returns 200
    [Documentation]    Template test for nested endpoint patterns
    /posts    1    comments
    /users    1    posts
    /users    1    todos
    /albums    1    photos

