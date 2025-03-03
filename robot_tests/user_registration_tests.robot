*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}              http://localhost:8080
${SIGNUP_URL}            ${BASE_URL}/signup
${LOGIN_URL}             ${BASE_URL}/login

# User Credentials
${VALID_USERNAME}        newusers1234
${VALID_PASSWORD}        password123
${SHORT_PASSWORD}        123

# Expected Messages
${MSG_USERNAME_EXISTS}   Username already exists
${MSG_INVALID_PASSWORD}  size must be between 7 and 30

*** Test Cases ***

User Registration
    [Documentation]  Registers a new user and verifies redirection to the login page.
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Fill Registration Form    ${VALID_USERNAME}    ${VALID_PASSWORD}    ${VALID_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Location Is    ${LOGIN_URL}
    Close Browser

User Registration With Existing Username
    [Documentation]  Attempts to register with an already taken username and verifies the error message.
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Fill Registration Form    ${VALID_USERNAME}    ${VALID_PASSWORD}    ${VALID_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${MSG_USERNAME_EXISTS}
    Close Browser

User Registration With Invalid Password
    [Documentation]  Attempts to register with a short password and verifies the error message.
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Fill Registration Form    ${VALID_USERNAME}    ${SHORT_PASSWORD}    ${SHORT_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${MSG_INVALID_PASSWORD}
    Close Browser

*** Keywords ***

Fill Registration Form
    [Arguments]    ${username}    ${password}    ${password_check}
    Input Text    xpath=//input[@name='username']    ${username}
    Input Text    xpath=//input[@name='password']    ${password}
    Input Text    xpath=//input[@name='passwordCheck']    ${password_check}

Wait Until Location Is
    [Arguments]    ${expected_url}
    ${current_url}=  Get Location
    Should Be Equal As Strings    ${current_url}    ${expected_url}
