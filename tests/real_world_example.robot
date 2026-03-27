*** Settings ***
Documentation    Comprehensive API test suite for JSONPlaceholder
...              covering happy path, unhappy path, and edge cases
Library          RequestsLibrary
Library          Collections
Library          String

*** Variables ***
${BASE_URL}      https://jsonplaceholder.typicode.com
${TEST_POST_ID}  1
${INVALID_ID}    99999

*** Keywords ***
Create API Session
    [Documentation]    Create a session to the JSONPlaceholder API
    Create Session      jsonplaceholder    ${BASE_URL}    verify=True

Validate JSON Response Structure
    [Documentation]    Validate that response contains expected fields
    [Arguments]         ${response}    ${expected_fields}
    ${json}=            Set Variable    ${response.json()}
    FOR    ${field}    IN    @{expected_fields}
        Should Be True    '${field}' in ${json}    Field '${field}' missing in response
    END

*** Test Cases ***
Happy Path - GET All Posts
    [Documentation]    Verify retrieving all posts returns 200 and contains data
    [Tags]             happy    get    posts    smoke
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /posts
    Status Should Be    200                ${response}
    ${posts}=           Set Variable       ${response.json()}
    Should Be True      ${posts.__len__()} > 0    No posts returned
    Log                 Retrieved ${posts.__len__()} posts

Happy Path - GET Single Post
    [Documentation]    Verify retrieving a specific post by ID
    [Tags]             happy    get    posts    smoke
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /posts/${TEST_POST_ID}
    Status Should Be    200                ${response}
    Validate JSON Response Structure    ${response}    ['id', 'title', 'body', 'userId']
    Should Be Equal As Integers    ${response.json()['id']}    ${TEST_POST_ID}

Happy Path - GET Comments for Post
    [Documentation]    Verify retrieving comments for a specific post
    [Tags]             happy    get    comments    relationship
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /posts/${TEST_POST_ID}/comments
    Status Should Be    200                ${response}
    ${comments}=        Set Variable       ${response.json()}
    Should Be True      ${comments.__len__()} > 0    Comments should exist for post ${TEST_POST_ID}

Happy Path - GET Comments by Query Parameter
    [Documentation]    Verify filtering comments by postId using query params
    [Tags]             happy    get    comments    query
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /comments    params=postId=${TEST_POST_ID}
    Status Should Be    200                ${response}
    ${comments}=        Set Variable       ${response.json()}
    FOR    ${comment}    IN    @{comments}
        Should Be Equal As Integers    ${comment['postId']}    ${TEST_POST_ID}
    END

Happy Path - POST Create New Post
    [Documentation]    Verify creating a new post returns 201
    [Tags]             happy    post    create    smoke
    Create API Session
    ${headers}=         Create Dictionary    Content-Type=application/json
    ${body}=            Create Dictionary    title=Robot Framework Test    body=This is a test post    userId=1
    ${response}=        POST On Session    jsonplaceholder    /posts    json=${body}    headers=${headers}
    Status Should Be    201                ${response}
    Validate JSON Response Structure    ${response}    ['id', 'title', 'body', 'userId']
    Should Be Equal As Strings    ${response.json()['title']}    Robot Framework Test

Happy Path - PUT Update Entire Post
    [Documentation]    Verify full update of existing post
    [Tags]             happy    put    update    full-update
    Create API Session
    ${headers}=         Create Dictionary    Content-Type=application/json
    ${body}=            Create Dictionary    id=${TEST_POST_ID}    title=Updated Title    body=Updated Body    userId=1
    ${response}=        PUT On Session    jsonplaceholder    /posts/${TEST_POST_ID}    json=${body}    headers=${headers}
    Status Should Be    200                ${response}
    Should Be Equal As Strings    ${response.json()['title']}    Updated Title

Happy Path - PATCH Partial Update
    [Documentation]    Verify partial update of existing post
    [Tags]             happy    patch    update    partial-update
    Create API Session
    ${headers}=         Create Dictionary    Content-Type=application/json
    ${body}=            Create Dictionary    title=Patched Title Only
    ${response}=        PATCH On Session    jsonplaceholder    /posts/${TEST_POST_ID}    json=${body}    headers=${headers}
    Status Should Be    200                ${response}
    Should Be Equal As Strings    ${response.json()['title']}    Patched Title Only
    Should Be Equal As Integers    ${response.json()['id']}    ${TEST_POST_ID}

Happy Path - DELETE Post
    [Documentation]    Verify deletion of existing post
    [Tags]             happy    delete    cleanup
    Create API Session
    ${response}=        DELETE On Session    jsonplaceholder    /posts/${TEST_POST_ID}
    Status Should Be    200                ${response}

Unhappy Path - GET Non-existent Post
    [Documentation]    Verify 404 when requesting non-existent post
    [Tags]             unhappy    get    negative    404
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /posts/${INVALID_ID}    expected_status=404
    Status Should Be    404                ${response}
    Log                 Correctly received 404 for non-existent post

Unhappy Path - Invalid Endpoint
    [Documentation]    Verify 404 when accessing invalid endpoint
    [Tags]             unhappy    get    negative    404    invalid
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /invalid_endpoint    expected_status=404
    Status Should Be    404                ${response}

Unhappy Path - POST with Missing Required Field
    [Documentation]    Verify API handles malformed requests
    [Tags]             unhappy    post    negative    validation
    Create API Session
    ${headers}=         Create Dictionary    Content-Type=application/json
    ${body}=            Create Dictionary    title=Missing Required Fields
    ${response}=        POST On Session    jsonplaceholder    /posts    json=${body}    headers=${headers}    expected_status=anything
    Log                 Response status: ${response.status_code}

Edge Case - GET All Albums
    [Documentation]    Verify albums endpoint returns expected data
    [Tags]             edge    get    albums
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /albums
    Status Should Be    200                ${response}
    ${albums}=          Set Variable       ${response.json()}
    Log                 Retrieved ${albums.__len__()} albums

Edge Case - GET All Users
    [Documentation]    Verify users endpoint returns all 10 users
    [Tags]             edge    get    users    smoke
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /users
    Status Should Be    200                ${response}
    ${users}=           Set Variable       ${response.json()}
    Should Be Equal As Integers    ${users.__len__()}    10    Expected 10 users

Edge Case - GET All Todos
    [Documentation]    Verify todos endpoint returns data
    [Tags]             edge    get    todos
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /todos
    Status Should Be    200                ${response}
    ${todos}=           Set Variable       ${response.json()}
    Log                 Retrieved ${todos.__len__()} todos

Edge Case - GET All Photos
    [Documentation]    Verify photos endpoint returns data (note: 5000 photos)
    [Tags]             edge    get    photos    performance
    Create API Session
    ${response}=        GET On Session    jsonplaceholder    /photos
    Status Should Be    200                ${response}
    ${photos}=          Set Variable       ${response.json()}
    Log                 Retrieved ${photos.__len__()} photos (should be 5000)