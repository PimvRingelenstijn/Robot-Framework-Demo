# Robot Framework: Complete Reference Guide for Back-end Testers

## Table of Contents
1. [What is Robot Framework?](#what-is-robot-framework)
2. [Why Use Robot Framework?](#why-use-robot-framework)
3. [How Robot Framework Works](#how-robot-framework-works)
4. [Project Structure](#project-structure)
5. [.robot File Syntax](#robot-file-syntax)
6. [File Setup](#file-setup)
7. [Section Specific Syntax](#section-specific-syntax)
8. [Variables in Robot Framework](#variable-types)
9. [Test Case Configuration](#test-case-configuration)
10. [Advanced Robot Framework Concepts](#advanced-robot-framework-concepts)
11. [Additional Information](#additional-information)
12. [Keywords for `*** Settings ***` Section](#keywords-for--settings--section)
13. [Keywords for `*** Test Cases ***` Settings](#keywords-for--test-cases--settings)
14. [Naming Convention](#naming-convention)
15. [Common Command Line Options](#common-command-line-options)

---

## What is Robot Framework?

Robot Framework is an **open-source, keyword-driven automation framework**. While it's most commonly used for testing, it can also be used for automating various tasks.

### Key Characteristics
- **Tabular, human-readable syntax**: Test files use a simple, readable format
- **Python-based**: The core framework and most official libraries are written in Python
- **Keyword-driven**: Tests are built using keywords that [[abstract]] away implementation details

---

## Why Use Robot Framework?

### 1. Keyword-Driven Architecture
- Keywords are comparable to function calls
- **High-level keywords**: Built from other keywords (business-readable)
- **Low-level keywords**: Implemented in Python code (technical implementation)

### 2. Readable Syntax
- Uses native `.robot` format with tabular structure
- Clean, business-readable test cases

### 3. Rich Ecosystem
Dozens of standard and external libraries are available. Popular libraries for back-end testing include:

| Library | Purpose |
|---------|---------|
| **RequestsLibrary** | API/REST testing |
| **DatabaseLibrary** | Database validation |
| **SSHLibrary** | Server/SSH operations |
| **Process** | Testing CLI tools |
| **JSONLibrary** | JSON manipulation and validation |

### 4. Parallel Execution
Run multiple tests simultaneously to reduce execution time.

### 5. Automated Reports
Generates detailed, interactive HTML reports and logs out of the box.

### 6. Extensibility
Custom keywords can be written in Python or Java when built-in functionality isn't sufficient.

### Additional Advantages

**Language Agnostic**
Robot Framework separates test logic from implementation, meaning testers don't need to be Python experts to write effective tests.

**Business-Readable**
Through custom, high-level keywords, you can abstract technical jargon away for non-technical stakeholders—even better than traditional Given/When/Then formats.

---

## How Robot Framework Works

Robot Framework operates on a **keyword-driven architecture** where test cases are composed of keywords that abstract the underlying implementation. The framework parses `.robot` files, executes keywords in sequence, and generates comprehensive reports and logs.


## Project Structure

A well-organized Robot Framework project follows a consistent structure to maintain scalability and reusability:

### Directory Purposes

| Directory | Purpose |
|-----------|---------|
| `tests/` | Contains the actual test case files. Each `.robot` file typically groups related test cases |
| `resources/` | Houses reusable keyword files and resource definitions that can be imported across test suites |
| `libraries/` | Contains custom Python libraries that implement low-level keywords for specialized functionality |
| `data/` | Stores static test data files (JSON, YAML, CSV) used for data-driven testing |
| `results/` | Destination for output files including logs, reports, and XML outputs |

---

## .robot File Syntax

### General Syntax Rules

Robot Framework uses a **tabular syntax** that relies on consistent spacing:

| Rule | Description |
|------|-------------|
| **2+ spaces or tabs** | Column separators. Use at least two spaces between cells |
| **Single spaces in keywords** | Keyword names can contain single spaces (unlike underscores in traditional programming) |
| **`...`** | Line continuation character. Used to split long lines across multiple rows |
| **`#`** | Comment character. Everything after `#` on a line is ignored |

---

## File Setup

Robot Framework files consist of header defined sections in `*** {header} ***` syntax.

**Convention:** Sections follow a specific order depending on the file function. Some sections may be omitted, but none are mandatory for Robot Framework.

### Settings
- **Convention:** 1st
- **Purpose:** Defines global configuration and imports through setting statements
```robot
*** Settings ***
Documentation     Robot Framework presentatie documentatie
Library 	  RequestsLibrary
```

### Variables
- **Convention:** 2nd
- **Purpose:** Defines variables used in test cases and keywords
```robot
*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com/
```

### Test Cases
- **Convention:** 3rd (only in test case files)
- **Purpose:** Contains the actual test cases
```robot
*** Test Cases ***
GET Request - Validate Status Code
    [Tags]    GET critical
    Create Session    api_session       ${BASE_URL}
    ${response}=      GET On Session    api_session    /posts/1
    Log Status And Body To Console      ${response}
```

### Keywords
- **Convention:** 3rd or 4th
- **Purpose:** Contains reusable keywords
- **Note:** Keywords can return data with the `[Return]` statement
```robot
*** Keywords ***
Log Status And Body To Console
    [Arguments]    ${response}
    Log To Console    Status: ${response.status_code}
    Log To Console    Body: ${response.content}
```

---

## Section Specific Syntax

### Common `*** Settings ***` Keywords

| Setting | Purpose |
|---------|---------|
| Documentation | Description of the test suite |
| Library | Import Python libraries |
| Resource | Import resource files |
| Variables | Import variable files |
| etc. | Additional configuration settings |


### Variable Types

| Type | Symbol | Syntax | Access |
|------|--------|--------|--------|
| Scalar (single value) | `$` | `${SCALAR_NAME}` | Direct variable usage |
| List | `@` | `@{LIST_NAME}` | `@{LIST_NAME}[index]` |
| Dictionary (map) | `&` | `&{DICT_NAME}` | `&{DICT_NAME}[key]` |
| Environment (system) | `%` | `%{ENV_NAME}` | System environment variables |

### Variable Declaration

You can declare variables in test cases and keywords by adding an `=` sign:

**Example:**
```robot
${new_scalar_variable}=    Create New Scalar
```

### Test Case Configuration

Test cases can have special keywords that define metadata or configuration:

| Setting | Purpose                                                                                                                                          |
|---------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| `[Documentation]` | Test documentation                                                                                                                               |
| `[Tags]` | Labels for filtering and grouping<br>• Can be used to run all tests with a specific label, for example `GET`<br>• Command: robot -i get .\tests\ |
| `[Setup]` | Keyword to run before test                                                                                                                       |
| `[Teardown]` | Keyword to run after test                                                                                                                        |
| etc. | Additional test case configuration options                                                                                                       |

---

## Advanced Robot Framework Concepts

### Test Templates

Test templates allow for executing the same keyword multiple times with different data sets, treating each set as an individual test case.

**Configuration:**
- Can be set in `*** Settings ***` with `Test Template` for all tests that fit the template
- Can also be set on an individual test case

**Example:**

```robot
*** Settings ***
Test Template    Login With Invalid Credentials

*** Test Cases ***         USERNAME        PASSWORD
Empty Username             ${EMPTY}       valid123
Empty Password             testuser       ${EMPTY}
Both Empty                 ${EMPTY}       ${EMPTY}
Wrong Credentials          wrong          wrong

*** Keywords ***
Login With Invalid Credentials
    [Arguments]    ${username}    ${password}
    Open Browser    ${URL}    chrome
    Input Text    username    ${username}
    Input Password    password    ${password}
    Click Button    login
    Page Should Contain    Login failed
    Close Browser
```
---

## Additional Information

Robot Framework has extensive documentation and a supportive community. The official documentation provides comprehensive guides, keyword libraries, and examples for expanding your test automation capabilities.
https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html

### Keywords for `*** Settings ***` Section

| Setting | Purpose | Example |
|---------|---------|---------|
| `Documentation` | Description of the test suite | `Documentation    Tests for login functionality` |
| `Library` | Import Python libraries | `Library    SeleniumLibrary` |
| `Resource` | Import resource files | `Resource    ../resources/common.robot` |
| `Variables` | Import variable files | `Variables    ../data/config.py` |
| `Suite Setup` | Run once before suite | `Suite Setup    Open Browser` |
| `Suite Teardown` | Run once after suite | `Suite Teardown    Close Browser` |
| `Test Setup` | Run before each test | `Test Setup    Clear Database` |
| `Test Teardown` | Run after each test | `Test Teardown    Take Screenshot` |
| `Test Template` | Data-driven testing | `Test Template    Login With Credentials` |
| `Force Tags` | Add tags to all tests | `Force Tags    production` |
| `Default Tags` | Default tags (can be overridden) | `Default Tags    regression` |


### Keywords for `*** Test Cases ***` Settings

| Setting | Purpose | Example |
|---------|---------|---------|
| `[Documentation]` | Description of what the test does | `[Documentation]    Verifies user can login with valid credentials` |
| `[Tags]` | Labels for filtering and grouping | `[Tags]    smoke    regression    login` |
| `[Setup]` | Keyword to run before the test | `[Setup]    Open Browser    ${URL}    chrome` |
| `[Teardown]` | Keyword to run after the test | `[Teardown]    Close All Browsers` |
| `[Template]` | Makes test case data-driven | `[Template]    Login With Credentials` |
| `[Timeout]` | Maximum execution time | `[Timeout]    2 minutes` |
| `[Template]` | Overrides suite-level template | `[Template]    Custom Keyword` |

### Naming Convention

| Element | Convention | Example |
|---------|------------|---------|
| Constants | `UPPER_SNAKE` for constants | `${BASE_URL}`, `${API_KEY}` |
| Variables | `lower_snake` for dynamic values | `${response}`, `${user_id}` |
| Keywords | Title Case With Spaces | `Create Session`, `GET On Session` |
| Sections | `*** Title Case ***` | `*** Settings ***`, `*** Variables ***` |
| Test cases | Sentence case with `-` separator | `GET Request - Validate Status Code` |
| Files | `lower_snake.robot` | `get_request.robot` |
| Directories | `lowercase/` | `tests/`, `resources/` |

### Common Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `--include` | Run tests with specific tag | `robot --include smoke tests/` |
| `--exclude` | Skip tests with specific tag | `robot --exclude wip tests/` |
| `--test` | Run specific test case | `robot --test "Check API" tests/` |
| `--suite` | Run specific test suite | `robot --suite api_tests tests/` |
| `--variable` | Set variable from CLI | `robot --variable ENV:prod tests/` |
| `--outputdir` | Specify output directory | `robot --outputdir results tests/` |