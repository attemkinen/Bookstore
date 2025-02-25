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

${EDITED_TITLE}       Muokattu kirja
${EDITED_AUTHOR}      Matti Muokkaaja
${EDITED_ISBN}        111-1-11111-1        
${EDITED_PRICE}       25.00
${EDITED_PUBLISHED}       2024

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

    
Edit Newest Book

    ${last_book_edit_link}=    Get Element Attribute    xpath=(//a[contains(@href, '/edit')])[last()]    href
    Go To    ${last_book_edit_link}

    # Päivitä pelin tiedot
    Input Text      xpath=//input[@name='title']        ${EDITED_TITLE}    
    Input Text      xpath=//input[@name='author']       ${EDITED_AUTHOR}
    Input Text      xpath=//input[@name='isbn']         ${EDITED_ISBN}
    Input Text      xpath=//input[@name='price']        ${EDITED_PRICE}
    Input Text      xpath=//input[@name='published']    ${EDITED_PUBLISHED}
    Select From List By Label    id=category    ${BOOK_CATEGORY}        ${BOOK_CATEGORY}

    # Lähetä muokattu lomake
    Click Button    xpath=//input[@type='submit']

    # Varmista, että muokatut tiedot näkyvät pelilistalla
    Wait Until Page Contains    ${EDITED_TITLE}


Delete Newest Book
    [Documentation]   Poistaa juuri muokatun kirjan listalta

    # Etsi uusimman muokatun kirjan delete-nappi ja paina sitä
    Click Link    xpath=(//a[contains(@href, '/deletebook')])[last()]

    # Varmista, että kirja on poistettu
    Reload Page
    Wait Until Page Does Not Contain    ${EDITED_TITLE}
    Close Browser

    
    


    

    