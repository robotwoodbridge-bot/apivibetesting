*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Resource          techshop_keywords.robot
Suite Setup       Create Techshop Session
Suite Teardown    Close Techshop Session


*** Keywords ***
Get Auth Headers
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    RETURN    ${headers}

Add Product To Cart And Get Item Id
    [Arguments]    ${headers}    ${product_id}=1    ${quantity}=2
    ${body}=    Create Dictionary    productId=${product_id}    quantity=${quantity}
    ${response}=    POST On Session    techshop    /cart    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    201
    FOR    ${item}    IN    @{response.json()}[items]
        IF    ${item}[productId] == ${product_id}
            RETURN    ${item}[id]
        END
    END
    Fail    Could not find cart item for product ${product_id} in response

Build Valid Order Payload
    ${item}=    Create Dictionary    productId=${1}    quantity=${2}
    ${items}=    Create List    ${item}
    ${shipping}=    Create Dictionary
    ...    firstName=Jane
    ...    lastName=Doe
    ...    email=jane@example.com
    ...    phone=0412345678
    ${payment}=    Create Dictionary
    ...    cardNumber=4111111111111111
    ...    expiryDate=12/28
    ...    cvv=123
    ${payload}=    Create Dictionary    items=${items}    shipping=${shipping}    payment=${payment}
    RETURN    ${payload}


*** Test Cases ***
# --- Auth: POST /auth/login ---

Login With Valid Credentials Returns Token
    ${body}=    Create Dictionary    email=${EMAIL}    password=${PASSWORD}
    ${response}=    POST On Session    techshop    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}[token]
    Should Be Equal    ${response.json()}[user][email]    ${EMAIL}

Login With Missing Email Returns 400
    ${body}=    Create Dictionary    password=password123
    ${response}=    POST On Session    techshop    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400

Login With Missing Password Returns 400
    ${body}=    Create Dictionary    email=demo@techshop.com
    ${response}=    POST On Session    techshop    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400

Login With Wrong Password Returns 401
    ${body}=    Create Dictionary    email=demo@techshop.com    password=wrongpassword
    ${response}=    POST On Session    techshop    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Login With Unknown Email Returns 401
    ${body}=    Create Dictionary    email=nonexistent@techshop.com    password=password123
    ${response}=    POST On Session    techshop    /auth/login    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401


# --- Products: GET /products ---

Get All Products Returns 200 And List
    ${response}=    GET On Session    techshop    /products    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be True    isinstance($response.json(), list)

Get Products With Nonexistent Category Returns Empty List
    ${params}=    Create Dictionary    category=nonexistent-category
    ${response}=    GET On Session    techshop    /products    params=${params}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Empty    ${response.json()}

Get Products With Injection String Category Returns Empty List
    ${params}=    Create Dictionary    category=<script>alert(1)</script>
    ${response}=    GET On Session    techshop    /products    params=${params}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Empty    ${response.json()}
    Should Not Contain    ${response.text}    <script>


# --- Products: GET /products/{id} ---

Get Product By Valid ID Returns 200
    ${response}=    GET On Session    techshop    /products/1    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Integers    ${response.json()}[id]    1

Get Product With Unknown ID Returns 404
    ${response}=    GET On Session    techshop    /products/99999    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404

Get Product With Invalid ID Format Does Not Return 500
    ${response}=    GET On Session    techshop    /products/abc    expected_status=any
    Should Contain    ${{[400, 404]}}    ${response.status_code}


# --- Cart: GET /cart ---

Get Cart With Valid Token Returns 200
    ${headers}=    Get Auth Headers
    ${response}=    GET On Session    techshop    /cart    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200

Get Cart Without Auth Header Returns 401
    ${response}=    GET On Session    techshop    /cart    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Get Cart With Invalid Token Returns 401
    ${headers}=    Create Dictionary    Authorization=Bearer invalid.token.value
    ${response}=    GET On Session    techshop    /cart    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401


# --- Cart: POST /cart ---

Add Item To Cart Returns 201
    ${headers}=    Get Auth Headers
    ${body}=    Create Dictionary    productId=${1}    quantity=${2}
    ${response}=    POST On Session    techshop    /cart    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    201

Add Item To Cart With Invalid Quantity Returns 400
    ${headers}=    Get Auth Headers
    ${body}=    Create Dictionary    productId=${1}    quantity=${0}
    ${response}=    POST On Session    techshop    /cart    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400

Add Item To Cart With Nonexistent Product Returns 404
    ${headers}=    Get Auth Headers
    ${body}=    Create Dictionary    productId=${99999}    quantity=${1}
    ${response}=    POST On Session    techshop    /cart    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404

Add Item To Cart Without Auth Header Returns 401
    ${body}=    Create Dictionary    productId=${1}    quantity=${2}
    ${response}=    POST On Session    techshop    /cart    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401


# --- Cart: PUT /cart/{itemId} ---

Update Cart Item Returns 200
    ${headers}=    Get Auth Headers
    ${item_id}=    Add Product To Cart And Get Item Id    ${headers}
    ${body}=    Create Dictionary    quantity=${3}
    ${response}=    PUT On Session    techshop    /cart/${item_id}    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200

Update Cart Item With Invalid Quantity Returns 400
    ${headers}=    Get Auth Headers
    ${item_id}=    Add Product To Cart And Get Item Id    ${headers}
    ${body}=    Create Dictionary    quantity=${0}
    ${response}=    PUT On Session    techshop    /cart/${item_id}    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400

Update Nonexistent Cart Item Returns 404
    ${headers}=    Get Auth Headers
    ${body}=    Create Dictionary    quantity=${2}
    ${response}=    PUT On Session    techshop    /cart/99999    json=${body}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404

Update Cart Item Without Auth Header Returns 401
    ${body}=    Create Dictionary    quantity=${2}
    ${response}=    PUT On Session    techshop    /cart/1    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401


# --- Cart: DELETE /cart/{itemId} ---

Remove Cart Item Returns 200
    ${headers}=    Get Auth Headers
    ${item_id}=    Add Product To Cart And Get Item Id    ${headers}
    ${response}=    DELETE On Session    techshop    /cart/${item_id}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200

Remove Nonexistent Cart Item Returns 404
    ${headers}=    Get Auth Headers
    ${response}=    DELETE On Session    techshop    /cart/99999    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404

Remove Cart Item Without Auth Header Returns 401
    ${response}=    DELETE On Session    techshop    /cart/1    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401


# --- Orders: GET /orders ---

Get Orders With Valid Token Returns 200
    ${headers}=    Get Auth Headers
    ${response}=    GET On Session    techshop    /orders    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be True    isinstance($response.json(), list)

Get Orders Without Auth Header Returns 401
    ${response}=    GET On Session    techshop    /orders    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Get Orders With Invalid Token Returns 401
    ${headers}=    Create Dictionary    Authorization=Bearer invalid.token.value
    ${response}=    GET On Session    techshop    /orders    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401


# --- Orders: POST /orders ---

Place Order With Valid Data Returns 201
    ${headers}=    Get Auth Headers
    ${payload}=    Build Valid Order Payload
    ${response}=    POST On Session    techshop    /orders    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    201

Place Order With Missing Required Field Returns 400
    ${headers}=    Get Auth Headers
    ${payload}=    Build Valid Order Payload
    Remove From Dictionary    ${payload}    shipping
    ${response}=    POST On Session    techshop    /orders    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400

Place Order With Invalid Payment Data Returns 400
    ${headers}=    Get Auth Headers
    ${payload}=    Build Valid Order Payload
    Set To Dictionary    ${payload}[payment]    cardNumber=1234
    ${response}=    POST On Session    techshop    /orders    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400

Place Order Without Auth Header Returns 401
    ${payload}=    Build Valid Order Payload
    ${response}=    POST On Session    techshop    /orders    json=${payload}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
