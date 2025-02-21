*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:8080
${SIGNUP_URL}         ${BASE_URL}/signup
${LOGIN_URL}          ${BASE_URL}/login
${BOOKS_URL}          ${BASE_URL}/books
${NEW_USERNAME}       newusers1234
${NEW_PASSWORD}       password123
${WRONG_USERNAME}     ABCDEFGH
${WRONG_PASSWORD}     ABCDEFGH
${SHORT_PASSWORD}     123
${SIGN_OUT_TEXT}      You have been logged out.
${LOGIN_DENIED_TEXT}  Invalid username and password.
${USERNAME_EXIST_TEXT}  Username already exists
${INVALID_PASSWORD_TEXT}  size must be between 7 and 30

*** Test Cases ***

# Rekisteröityminen
Sign Up Test
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Input Text    xpath=//input[@name='username']    ${NEW_USERNAME}
    Input Text    xpath=//input[@name='password']    ${NEW_PASSWORD}
    Input Text    xpath=//input[@name='passwordCheck']    ${NEW_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    ${LOGIN_URL}
    Close Browser

# Epäonnistuneet rekisteröitymiset
Sign Up With Existing Username
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Input Text    xpath=//input[@name='username']    ${NEW_USERNAME}
    Input Text    xpath=//input[@name='password']    ${NEW_PASSWORD}
    Input Text    xpath=//input[@name='passwordCheck']    ${NEW_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${USERNAME_EXIST_TEXT}
    Close Browser

Sign Up With Invalid Password
    Open Browser    ${SIGNUP_URL}    Chrome
    Maximize Browser Window
    Input Text    xpath=//input[@name='username']    ${NEW_USERNAME}
    Input Text    xpath=//input[@name='password']    ${SHORT_PASSWORD}
    Input Text    xpath=//input[@name='passwordCheck']    ${SHORT_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${INVALID_PASSWORD_TEXT}
    Close Browser

# Kirjautuminen
Login with Wrong Username
    Open Browser    ${LOGIN_URL}    Chrome
    Input Text    xpath=//input[@name='username']    ${WRONG_USERNAME}
    Input Text    xpath=//input[@name='password']    ${WRONG_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${LOGIN_DENIED_TEXT}
    Close Browser

Login Test
    Open Browser    ${LOGIN_URL}    Chrome
    Maximize Browser Window
    Input Text    xpath=//input[@name='username']    ${NEW_USERNAME}
    Input Text    xpath=//input[@name='password']    ${NEW_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    books
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    ${BOOKS_URL}

# Uloskirjautuminen
Sign Out Test
    Click Button    xpath=//input[@type='submit' and @value='Sign Out']
    Wait Until Page Contains    ${SIGN_OUT_TEXT}
    Close Browser
