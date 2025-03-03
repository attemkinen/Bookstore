*** Settings ***
Library     SeleniumLibrary

*** Variables ***

# Base URLs
${BASE_URL}           http://localhost:8080
${LOGIN_URL}          ${BASE_URL}/login
${CATEGORY_FORM_URL}  ${BASE_URL}/newcategory
${SAVE_CATEGORY_URL}    ${BASE_URL}/savecategory  
${ADD_CATEGORY_URL}     ${BASE_URL}/addcategory   

# Admin Credentials
${ADMIN_USERNAME}     admin
${ADMIN_PASSWORD}     admin

# Category Data (Original)
${CATEGORY_NAME}        Test Category
${WRONG_NAME_MESSAGE}       Kategorian nimi saa sisältää vain kirjaimia
${EMPTY_NAME_MESSAGE}       Kategorian nimi ei voi olla tyhjä
${NUMERICAL_NAME}       123        
${EMPTY_CHAR}
${INVALID_CHAR}     !¤&$



*** Test Cases ***

Admin Login

    [Documentation]  Logs in as an admin user to access category management features.

    Open Browser    ${LOGIN_URL}    Chrome
    Input Text      name=username   ${ADMIN_USERNAME}
    Input Text      name=password   ${ADMIN_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    
    ${welcome_text}=    Get Text    xpath=//h3
    Should Contain    ${welcome_text}    Welcome ${ADMIN_USERNAME}

Reject Category With Invalid Numerical Characters

    [Documentation]     Checks that new category cannot be saved with only numerical characters

    Click Link      xpath=(//a[contains(@href, '/addcategory')])
    Input Text      xpath=//input[@name='name']     ${NUMERICAL_NAME}        
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${WRONG_NAME_MESSAGE}
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${SAVE_CATEGORY_URL}  


Reject Category Without Characters

    [Documentation]     Checks that new category cannot be saved without any characters.

    Input Text      xpath=//input[@name='name']    ${EMPTY_CHAR}       
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${EMPTY_NAME_MESSAGE}  
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${SAVE_CATEGORY_URL}  

    

Reject Category With Invalid Characters

    [Documentation]     Checks that new category cannot be saved with invalid characters.

    Input Text      xpath=//input[@name='name']    ${INVALID_CHAR}       
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${WRONG_NAME_MESSAGE}  
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${SAVE_CATEGORY_URL}  

    Close Browser