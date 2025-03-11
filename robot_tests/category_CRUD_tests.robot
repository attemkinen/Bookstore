*** Settings ***
Library     SeleniumLibrary

*** Variables ***
# Base URLs
${BASE_URL}           http://localhost:8080
${LOGIN_URL}          ${BASE_URL}/login
${CATEGORY_FORM_URL}  ${BASE_URL}/newcategory
${SAVE_CATEGORY_URL}    ${BASE_URL}/savecategory     

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

# Category Data (Edited)
${EDITED_CATEGORY}    Updated Category

*** Test Cases ***

Admin Login

    [Documentation]  Logs in as an admin user to access category management features.

    Open Browser    ${LOGIN_URL}    Chrome
    Input Text      name=username   ${ADMIN_USERNAME}
    Input Text      name=password   ${ADMIN_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    Wait Until Element Is Visible    xpath=//h3
    ${welcome_text}=    Get Text    xpath=//h3
    Should Contain    ${welcome_text}    Welcome ${ADMIN_USERNAME}

Add New Category

    [Documentation]  Adds a new category with predefined details.

    Click Link      xpath=//a[contains(@href, '/addcategory')] 
    Input Text      xpath=//input[@name='name']        ${CATEGORY_NAME}    
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${CATEGORY_NAME}

Edit Most Recent Category

    [Documentation]  Edits the most recently added category by navigating to its edit page and updating details.

    ${last_category_edit_link}=    Get Element Attribute    xpath=(//a[contains(@href, '/editCategory')])[last()]    href
    Go To    ${last_category_edit_link}
    Input Text      xpath=//input[@name='name']        ${EDITED_CATEGORY}    
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${EDITED_CATEGORY}

Delete Most Recent Category

    [Documentation]  Deletes the most recently edited category from the list.
    
    Click Link    xpath=(//a[contains(@href, '/deletecategory')])[last()]
    Reload Page
    Wait Until Page Does Not Contain    ${EDITED_CATEGORY}
    
    Close Browser
