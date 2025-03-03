*** Settings ***
Library     SeleniumLibrary

*** Variables ***

# Base URLs
${BASE_URL}           http://localhost:8080
${LOGIN_URL}          ${BASE_URL}/login
${BOOK_FORM_URL}      ${BASE_URL}/newbook
${SAVE_BOOK_URL}      ${BASE_URL}/savebook

# Admin Credentials
${ADMIN_USERNAME}     admin
${ADMIN_PASSWORD}     admin

# Valid Book Data
${VALID_TITLE}       Test Book
${VALID_AUTHOR}      John Doe
${VALID_ISBN}        112-223-334-4455
${VALID_PRICE}       20.99
${VALID_PUBLISHED}   2020

# Invalid Book Data
${EMPTY_FIELD}       
${INVALID_ISBN}      1122233344455
${NEGATIVE_PRICE}    -10.99
${LOW_PUBLISHED}     999
${FUTURE_PUBLISHED}  2030

# Validation Messages
${EMPTY_TITLE_MESSAGE}      Title cannot be empty
${EMPTY_AUTHOR_MESSAGE}     Author cannot be empty
${EMPTY_PRICE_MESSAGE}      Price must be a positive number
${INVALID_ISBN_MESSAGE}     Invalid ISBN format (expected: 123-456-789-0123)
${NEGATIVE_PRICE_MESSAGE}   Price must be a positive number
${LOW_PUBLISHED_MESSAGE}    Year must be at least 1000
${FUTURE_PUBLISHED_MESSAGE}     Year cannot be in the future



*** Test Cases ***

Admin Login
    [Documentation]  Logs in as an admin user to access book management features.
    Open Browser    ${LOGIN_URL}    Chrome
    Input Text      name=username   ${ADMIN_USERNAME}
    Input Text      name=password   ${ADMIN_PASSWORD}
    Click Button    xpath=//input[@type='submit']
    ${welcome_text}=    Get Text    xpath=//h3
    Should Contain    ${welcome_text}    Welcome ${ADMIN_USERNAME}

Validate Successful Book Addition
    [Documentation]  Ensures a valid book can be added successfully.
    Go To           ${BOOK_FORM_URL}
    Input Text      xpath=//input[@name='title']      ${VALID_TITLE}
    Input Text      xpath=//input[@name='author']     ${VALID_AUTHOR}
    Input Text      xpath=//input[@name='isbn']       ${VALID_ISBN}
    Input Text      xpath=//input[@name='price']      ${VALID_PRICE}
    Input Text      xpath=//input[@name='published']  ${VALID_PUBLISHED}
    Click Button    xpath=//input[@type='submit']
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${BASE_URL}/books

Reject Book With Empty Fields
    [Documentation]  Ensures a book cannot be added with empty required fields.
    Go To           ${BOOK_FORM_URL}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${EMPTY_TITLE_MESSAGE}
    Wait Until Page Contains        ${EMPTY_AUTHOR_MESSAGE}
    Wait Until Page Contains        ${INVALID_ISBN_MESSAGE} 
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${SAVE_BOOK_URL}

Reject Book With Invalid ISBN
    [Documentation]  Ensures a book cannot be added with an incorrectly formatted ISBN.
    Go To           ${BOOK_FORM_URL}
    Input Text      xpath=//input[@name='title']      ${VALID_TITLE}
    Input Text      xpath=//input[@name='author']     ${VALID_AUTHOR}
    Input Text      xpath=//input[@name='isbn']       ${INVALID_ISBN}
    Input Text      xpath=//input[@name='price']      ${VALID_PRICE}
    Input Text      xpath=//input[@name='published']  ${VALID_PUBLISHED}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${INVALID_ISBN_MESSAGE}
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${SAVE_BOOK_URL}

Reject Book With Negative Price
    [Documentation]  Ensures a book cannot be added with a negative price.
    Go To           ${BOOK_FORM_URL}
    Input Text      xpath=//input[@name='title']      ${VALID_TITLE}
    Input Text      xpath=//input[@name='author']     ${VALID_AUTHOR}
    Input Text      xpath=//input[@name='isbn']       ${VALID_ISBN}
    Input Text      xpath=//input[@name='price']      ${NEGATIVE_PRICE}
    Input Text      xpath=//input[@name='published']  ${VALID_PUBLISHED}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${NEGATIVE_PRICE_MESSAGE}
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${SAVE_BOOK_URL}

Reject Book With Invalid Published Year
    [Documentation]  Ensures a book cannot be added with a published year outside the allowed range.
    Go To           ${BOOK_FORM_URL}
    Input Text      xpath=//input[@name='title']      ${VALID_TITLE}
    Input Text      xpath=//input[@name='author']     ${VALID_AUTHOR}
    Input Text      xpath=//input[@name='isbn']       ${VALID_ISBN}
    Input Text      xpath=//input[@name='price']      ${VALID_PRICE}
    Input Text      xpath=//input[@name='published']  ${LOW_PUBLISHED}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${LOW_PUBLISHED_MESSAGE} 
    
    Input Text      xpath=//input[@name='published']  ${FUTURE_PUBLISHED}
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains        ${FUTURE_PUBLISHED_MESSAGE}
    
    ${current_url}=  Get Location
    Should Be Equal  ${current_url}  ${SAVE_BOOK_URL}

Close Browser
    Close Browser
