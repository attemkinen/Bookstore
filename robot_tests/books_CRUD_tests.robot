*** Settings ***
Library     SeleniumLibrary

*** Variables ***
# Base URLs
${BASE_URL}         http://localhost:8080
${LOGIN_URL}        ${BASE_URL}/login
${BOOK_FORM_URL}    ${BASE_URL}/newbook

# Admin Credentials
${ADMIN_USERNAME}   admin
${ADMIN_PASSWORD}   admin

# Book Data (Original)
${BOOK_TITLE}       Test Book
${BOOK_AUTHOR}      John Doe
${BOOK_ISBN}        951-1-12345-8        
${BOOK_PRICE}       20.00
${BOOK_YEAR}        2025
${BOOK_CATEGORY}    Drama

# Book Data (Edited)
${EDITED_TITLE}     Updated Book
${EDITED_AUTHOR}    Jane Doe
${EDITED_ISBN}      111-1-11111-1        
${EDITED_PRICE}     25.00
${EDITED_YEAR}      2024

*** Test Cases ***

Admin Login
    [Documentation]  Logs in as an admin user to access book management features.
    Open Browser    ${LOGIN_URL}    Chrome
    Input Text      name=username   ${ADMIN_USERNAME}
    Input Text      name=password   ${ADMIN_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    
    ${welcome_text}=    Get Text    xpath=//h3
    Should Contain    ${welcome_text}    Welcome ${ADMIN_USERNAME}

Add New Book
    [Documentation]  Adds a new book with predefined details.
    Click Link      xpath=//a[contains(@href, '/newbook')] 
    Input Text      xpath=//input[@name='title']        ${BOOK_TITLE}    
    Input Text      xpath=//input[@name='author']       ${BOOK_AUTHOR}
    Input Text      xpath=//input[@name='isbn']         ${BOOK_ISBN}
    Input Text      xpath=//input[@name='price']        ${BOOK_PRICE}
    Input Text      xpath=//input[@name='published']    ${BOOK_YEAR}
    Select From List By Label    id=category    ${BOOK_CATEGORY}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${BOOK_TITLE}

Edit Most Recent Book
    [Documentation]  Edits the most recently added book by navigating to its edit page and updating details.
    ${last_book_edit_link}=    Get Element Attribute    xpath=(//a[contains(@href, '/edit')])[last()]    href
    Go To    ${last_book_edit_link}
    Input Text      xpath=//input[@name='title']        ${EDITED_TITLE}    
    Input Text      xpath=//input[@name='author']       ${EDITED_AUTHOR}
    Input Text      xpath=//input[@name='isbn']         ${EDITED_ISBN}
    Input Text      xpath=//input[@name='price']        ${EDITED_PRICE}
    Input Text      xpath=//input[@name='published']    ${EDITED_YEAR}
    Select From List By Label    id=category    ${BOOK_CATEGORY}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    ${EDITED_TITLE}

Delete Most Recent Book
    [Documentation]  Deletes the most recently edited book from the list.
    Click Link    xpath=(//a[contains(@href, '/deletebook')])[last()]
    Reload Page
    Wait Until Page Does Not Contain    ${EDITED_TITLE}
    Close Browser