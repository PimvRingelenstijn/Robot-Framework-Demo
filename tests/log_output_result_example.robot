*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    https://jsonplaceholder.typicode.com

*** Test Cases ***
Demonstrate Output vs Log vs Report
    [Documentation]    This test shows what appears in each output file

    # This Log message appears ONLY in log.html (and output.xml as raw data)
    Log    🔍 Starting API test demonstration    level=INFO

    # This appears in all three files, but differently
    Create Session    jsonplaceholder    ${BASE_URL}

    # This request details appear in all three files
    ${response}=    GET On Session    jsonplaceholder    /posts/1

    # This validation appears in all three files
    Status Should Be    200    ${response}

    # This detailed debug appears ONLY in log.html and output.xml
    Log    Response body: ${response.json()}    level=DEBUG

    # This performance metric appears in all three files
    Log    Response time: ${response.elapsed.total_seconds()}s    level=INFO

    # This warning appears in all three files
    Log    This is a sample warning message    level=WARN