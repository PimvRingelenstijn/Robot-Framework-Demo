*** Settings ***
Documentation    Simple example showing basic Robot Framework structure
...              for API testing with JSONPlaceholder
Library          RequestsLibrary
Library          Collections

*** Variables ***
${BASE_URL}      https://jsonplaceholder.typicode.com

*** Test Cases ***
Basic GET Request Returns 200 OK
    [Documentation]    Simple test to verify API connectivity
    ...                by making a GET request to /posts and checking status
    Create Session    jsonplaceholder    ${BASE_URL}
    ${response}=      GET On Session    jsonplaceholder    /posts
    Status Should Be  200                 ${response}
    Log                Response status: ${response.status_code}
    Log                Number of posts returned: ${response.json().__len__()}