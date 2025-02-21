*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${BASE_URL}         http://localhost:8080
${LOGIN_URL}        ${BASE_URL}/login
${ADD_URL}          ${BASE_URL}/newbook
${USERNAME}         admin
${PASSWORD}         admin
${BOOK_TITLE}       Testi kirja
${BOOK_AUTHOR}      Matti Testaaja
${BOOK_ISBN}        951-1-12345-8        
${BOOK_PRICE}       20.00
${BOOK_PUBLISHED}       2025
${BOOK_CATEGORY}        Drama

*** Test Cases ***

Login Before Adding New Book
    [Documentation]   Before adding new books user has to be logged in

    # Log in
    Open Browser    ${LOGIN_URL}    Chrome
    Input Text  name=username   ${USERNAME}
    Input Text  name=password   ${PASSWORD}
    Click Button    xpath=//input[@type='submit']
    ${welcome_text}=    Get Text    xpath=//h3
    Should Contain    ${welcome_text}    Welcome ${USERNAME}

Add New Book

    # navigate to add new book
    Click Link    xpath=//a[contains(@href, '/newbook')] 

    # Fill in info for book
    Input Text      xpath=//input[@name='title']        ${BOOK_TITLE}    
    Input Text      xpath=//input[@name='author']       ${BOOK_AUTHOR}
    Input Text      xpath=//input[@name='isbn']         ${BOOK_ISBN}
    Input Text      xpath=//input[@name='price']        ${BOOK_PRICE}
    Input Text      xpath=//input[@name='published']    ${BOOK_PUBLISHED}
    Select From List By Label    id=category    ${BOOK_CATEGORY}        ${BOOK_CATEGORY}

    # Submit new Book
    Click Button        xpath=//input[@type='submit']
    Wait Until Page Contains    ${BOOK_TITLE}

    Close Browser

    

    