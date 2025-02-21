*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# Base URLs
${BASE_URL}          http://localhost:8080
${SIGNUP_URL}        ${BASE_URL}/signup
${LOGIN_URL}         ${BASE_URL}/login
${BOOKS_URL}         ${BASE_URL}/books

# User Credentials
${VALID_USERNAME}    newusers1234
${VALID_PASSWORD}    password123
${INVALID_USERNAME}  ABCDEFGH
${INVALID_PASSWORD}  ABCDEFGH
${SHORT_PASSWORD}    123

# Expected Messages
${MSG_SIGN_OUT}       You have been logged out.
${MSG_LOGIN_DENIED}   Invalid username and password.
${MSG_USERNAME_EXISTS} Username already exists
${MSG_INVALID_PASSWORD} size must be between 7 and 30

*** Test Cases ***

User Registration
    [Documentation]  Registers a new user and verifies redirection to the login page.
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Input Text      xpath=//input[@name='username']    ${VALID_USERNAME}
    Input Text      xpath=//input[@name='password']    ${VALID_PASSWORD}
    Input Text      xpath=//input[@name='passwordCheck']    ${VALID_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    
    ${current_url}=  Get Location
    Should Be Equal As Strings    ${current_url}    ${LOGIN_URL}
    Close Browser

User Registration With Existing Username
    [Documentation]  Attempts to register a user with an already taken username and verifies the error message.
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Input Text      xpath=//input[@name='username']    ${VALID_USERNAME}
    Input Text      xpath=//input[@name='password']    ${VALID_PASSWORD}
    Input Text      xpath=//input[@name='passwordCheck']    ${VALID_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    
    Wait Until Page Contains    ${MSG_USERNAME_EXISTS}
    Close Browser

User Registration With Invalid Password
    [Documentation]  Attempts to register with a short password and verifies the error message.
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Input Text      xpath=//input[@name='username']    ${VALID_USERNAME}
    Input Text      xpath=//input[@name='password']    ${SHORT_PASSWORD}
    Input Text      xpath=//input[@name='passwordCheck']    ${SHORT_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    
    Wait Until Page Contains    ${MSG_INVALID_PASSWORD}
    Close Browser

User Login With Invalid Credentials
    [Documentation]  Attempts to log in with incorrect username and password, then verifies the error message.
    Open Browser    ${LOGIN_URL}    Chrome
    Input Text      xpath=//input[@name='username']    ${INVALID_USERNAME}
    Input Text      xpath=//input[@name='password']    ${INVALID_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    
    Wait Until Page Contains    ${MSG_LOGIN_DENIED}
    Close Browser

User Login
    [Documentation]  Logs in with valid credentials and verifies redirection to the books page.
    Open Browser    ${LOGIN_URL}    Chrome
    Maximize Browser Window
    Input Text      xpath=//input[@name='username']    ${VALID_USERNAME}
    Input Text      xpath=//input[@name='password']    ${VALID_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    
    Wait Until Page Contains    books
    ${current_url}=  Get Location
    Should Be Equal As Strings    ${current_url}    ${BOOKS_URL}

User Logout
    [Documentation]  Logs out the user and verifies the logout message is displayed.
    Click Button    xpath=//input[@type='submit' and @value='Sign Out']
    Wait Until Page Contains    ${MSG_SIGN_OUT}
    Close Browser
