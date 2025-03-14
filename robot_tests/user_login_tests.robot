*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}             http://localhost:8080
${SIGNUP_URL}           ${BASE_URL}/signup
${LOGIN_URL}            ${BASE_URL}/login
${BOOKS_URL}            ${BASE_URL}/books

# User Credentials
${VALID_USERNAME}       admin
${VALID_PASSWORD}       admin
${SHORT_PASSWORD}       123

# Expected Messages
${MSG_SIGN_OUT}         You have been logged out.
${MSG_LOGIN_DENIED}     Invalid username and password.
${MSG_USERNAME_EXISTS}  Username already exists
${MSG_INVALID_PASSWORD}  size must be between 7 and 30

*** Test Cases ***


User Login
    [Documentation]  Logs in with valid credentials and verifies redirection to the books page.
    Open Browser    ${LOGIN_URL}    Chrome
    Maximize Browser Window
    Perform Login   ${VALID_USERNAME}   ${VALID_PASSWORD}
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${BOOKS_URL} 
    Wait Until Element Is Visible    xpath=//h3
    ${welcome_text}=    Get Text    xpath=//h3
    Should Contain    ${welcome_text}    Welcome ${VALID_USERNAME} 
    

User Logout
    [Documentation]  Logs out the user and verifies the logout message is displayed.
    Click Button    xpath=//input[@type='submit' and @value='Sign Out']
    Wait Until Page Contains    ${MSG_SIGN_OUT}
    Close Browser

User Login With Invalid Credentials
    [Documentation]  Attempts to log in with incorrect credentials and verifies the error message.
    Open Browser    ${LOGIN_URL}    Chrome
    Maximize Browser Window
    Perform Login    ABCDEFGH    ABCDEFGH
    Wait Until Page Contains    ${MSG_LOGIN_DENIED}
    Close Browser
    
*** Keywords ***

Perform Login
    [Arguments]    ${username}    ${password}
    Input Text    xpath=//input[@name='username']    ${username}
    Input Text    xpath=//input[@name='password']    ${password}
    Click Button    xpath=//input[@type='submit']
    Sleep    1s    # Varmistetaan, että sivu ehtii päivittyä

Wait Until Location Is
    [Arguments]    ${expected_url}
    ${current_url}=  Get Location
    Should Be Equal As Strings    ${current_url}    ${expected_url}
