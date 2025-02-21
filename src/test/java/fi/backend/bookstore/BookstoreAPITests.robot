*** Settings ***
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       http://localhost:8080

*** Test Cases ***

Get All Books
    [Documentation]    Verify we can get a list of all books
    Create Session    bookstore    ${BASE_URL}
    ${response}=      GET    bookstore/booksjson
    Status Should Be  200
    Log               ${response.json()}

Get Book By ID
    [Documentation]    Verify we can fetch a book by its ID
    Create Session    bookstore    ${BASE_URL}
    ${response}=      GET    bookstore/booksjson/1
    Status Should Be  200
    Dictionary Should Contain Key    ${response.json()}    title

Create New Book
    [Documentation]    Verify we can add a new book
    Create Session    bookstore    ${BASE_URL}
    ${new_book}=      Create Dictionary    title=Physics Basics    author=Jane Doe    isbn=123-456-789    price=29.99    published=2020    category={"categoryId": 1}
    ${response}=      POST    bookstore/booksjson    json=${new_book}
    Status Should Be  200
    Dictionary Should Contain Key    ${response.json()}    id
