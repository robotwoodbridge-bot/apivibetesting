import os

import pytest
import requests

BASE_URL = os.getenv("BASE_URL", "http://localhost:3001")


@pytest.fixture
def auth_token():
    email = os.getenv("TEST_EMAIL")
    password = os.getenv("TEST_PASSWORD")
    if not email or not password:
        raise RuntimeError(
            "TEST_EMAIL and TEST_PASSWORD environment variables must be set to run authenticated tests."
        )

    response = requests.post(
        f"{BASE_URL}/auth/login",
        json={"email": email, "password": password},
    )
    assert response.status_code == 200
    return response.json()["token"]


@pytest.fixture
def auth_headers(auth_token):
    return {"Authorization": f"Bearer {auth_token}"}


@pytest.fixture
def cart_item(auth_headers):
    response = requests.post(
        f"{BASE_URL}/cart",
        json={"productId": 1, "quantity": 2},
        headers=auth_headers,
    )
    assert response.status_code == 201
    items = response.json()["items"]
    item = next(item for item in items if item["productId"] == 1)
    return item["id"]


# --- Auth: POST /auth/login ---

def test_login_valid_credentials():
    email = os.getenv("TEST_EMAIL")
    password = os.getenv("TEST_PASSWORD")
    if not email or not password:
        raise RuntimeError(
            "TEST_EMAIL and TEST_PASSWORD environment variables must be set to run this test."
        )

    response = requests.post(
        f"{BASE_URL}/auth/login",
        json={"email": email, "password": password},
    )

    assert response.status_code == 200
    body = response.json()
    assert isinstance(body["token"], str)
    assert body["user"]["email"] == email


def test_login_missing_email_returns_400():
    response = requests.post(
        f"{BASE_URL}/auth/login",
        json={"password": "password123"},
    )

    assert response.status_code == 400


def test_login_missing_password_returns_400():
    response = requests.post(
        f"{BASE_URL}/auth/login",
        json={"email": "demo@techshop.com"},
    )

    assert response.status_code == 400


def test_login_wrong_password_returns_401():
    response = requests.post(
        f"{BASE_URL}/auth/login",
        json={"email": "demo@techshop.com", "password": "wrongpassword"},
    )

    assert response.status_code == 401


def test_login_unknown_email_returns_401():
    response = requests.post(
        f"{BASE_URL}/auth/login",
        json={"email": "nonexistent@techshop.com", "password": "password123"},
    )

    assert response.status_code == 401


# --- Products: GET /products ---

def test_get_products_returns_200_and_list():
    response = requests.get(f"{BASE_URL}/products")

    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_get_products_nonexistent_category_returns_empty_list():
    response = requests.get(
        f"{BASE_URL}/products",
        params={"category": "nonexistent-category"},
    )

    assert response.status_code == 200
    assert response.json() == []


def test_get_products_injection_category_returns_empty_list_no_error():
    response = requests.get(
        f"{BASE_URL}/products",
        params={"category": "<script>alert(1)</script>"},
    )

    assert response.status_code == 200
    assert response.json() == []
    assert "<script>" not in response.text


# --- Products: GET /products/{id} ---

def test_get_product_by_id_valid_returns_200():
    response = requests.get(f"{BASE_URL}/products/1")

    assert response.status_code == 200
    assert response.json()["id"] == 1


def test_get_product_not_found_returns_404():
    response = requests.get(f"{BASE_URL}/products/99999")

    assert response.status_code == 404


def test_get_product_invalid_id_format_not_500():
    response = requests.get(f"{BASE_URL}/products/abc")

    assert response.status_code in (400, 404)


# --- Cart: GET /cart ---

def test_get_cart_valid_token_returns_200(auth_headers):
    response = requests.get(f"{BASE_URL}/cart", headers=auth_headers)

    assert response.status_code == 200


def test_get_cart_no_auth_header_returns_401():
    response = requests.get(f"{BASE_URL}/cart")

    assert response.status_code == 401


def test_get_cart_invalid_token_returns_401():
    headers = {"Authorization": "Bearer invalid.token.value"}
    response = requests.get(f"{BASE_URL}/cart", headers=headers)

    assert response.status_code == 401


# --- Cart: POST /cart ---

def test_add_to_cart_valid_returns_201(auth_headers):
    response = requests.post(
        f"{BASE_URL}/cart",
        json={"productId": 1, "quantity": 2},
        headers=auth_headers,
    )

    assert response.status_code == 201


@pytest.mark.parametrize("quantity", [0, -1, -100])
def test_add_to_cart_invalid_quantity_returns_400(auth_headers, quantity):
    response = requests.post(
        f"{BASE_URL}/cart",
        json={"productId": 1, "quantity": quantity},
        headers=auth_headers,
    )

    assert response.status_code == 400


def test_add_to_cart_nonexistent_product_returns_404(auth_headers):
    response = requests.post(
        f"{BASE_URL}/cart",
        json={"productId": 99999, "quantity": 1},
        headers=auth_headers,
    )

    assert response.status_code == 404


def test_add_to_cart_no_auth_header_returns_401():
    response = requests.post(
        f"{BASE_URL}/cart",
        json={"productId": 1, "quantity": 2},
    )

    assert response.status_code == 401


# --- Cart: PUT /cart/{itemId} ---

def test_update_cart_item_valid_returns_200(auth_headers, cart_item):
    response = requests.put(
        f"{BASE_URL}/cart/{cart_item}",
        json={"quantity": 3},
        headers=auth_headers,
    )

    assert response.status_code == 200


@pytest.mark.parametrize("quantity", [0, -1, -100])
def test_update_cart_item_invalid_quantity_returns_400(auth_headers, cart_item, quantity):
    response = requests.put(
        f"{BASE_URL}/cart/{cart_item}",
        json={"quantity": quantity},
        headers=auth_headers,
    )

    assert response.status_code == 400


def test_update_cart_item_not_found_returns_404(auth_headers):
    response = requests.put(
        f"{BASE_URL}/cart/99999",
        json={"quantity": 2},
        headers=auth_headers,
    )

    assert response.status_code == 404


def test_update_cart_item_no_auth_header_returns_401():
    response = requests.put(
        f"{BASE_URL}/cart/1",
        json={"quantity": 2},
    )

    assert response.status_code == 401


# --- Cart: DELETE /cart/{itemId} ---

def test_remove_cart_item_valid_returns_200(auth_headers, cart_item):
    response = requests.delete(f"{BASE_URL}/cart/{cart_item}", headers=auth_headers)

    assert response.status_code == 200


def test_remove_cart_item_not_found_returns_404(auth_headers):
    response = requests.delete(f"{BASE_URL}/cart/99999", headers=auth_headers)

    assert response.status_code == 404


def test_remove_cart_item_no_auth_header_returns_401():
    response = requests.delete(f"{BASE_URL}/cart/1")

    assert response.status_code == 401


# --- Orders: GET /orders ---

def test_get_orders_valid_token_returns_200(auth_headers):
    response = requests.get(f"{BASE_URL}/orders", headers=auth_headers)

    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_get_orders_no_auth_header_returns_401():
    response = requests.get(f"{BASE_URL}/orders")

    assert response.status_code == 401


def test_get_orders_invalid_token_returns_401():
    headers = {"Authorization": "Bearer invalid.token.value"}
    response = requests.get(f"{BASE_URL}/orders", headers=headers)

    assert response.status_code == 401


# --- Orders: POST /orders ---

VALID_ORDER_PAYLOAD = {
    "items": [{"productId": 1, "quantity": 2}],
    "shipping": {
        "firstName": "Jane",
        "lastName": "Doe",
        "email": "jane@example.com",
        "phone": "0412345678",
    },
    "payment": {
        "cardNumber": "4111111111111111",
        "expiryDate": "12/28",
        "cvv": "123",
    },
}


def test_place_order_valid_returns_201(auth_headers):
    response = requests.post(
        f"{BASE_URL}/orders",
        json=VALID_ORDER_PAYLOAD,
        headers=auth_headers,
    )

    assert response.status_code == 201


def test_place_order_missing_required_field_returns_400(auth_headers):
    payload = {
        "items": VALID_ORDER_PAYLOAD["items"],
        "payment": VALID_ORDER_PAYLOAD["payment"],
    }
    response = requests.post(f"{BASE_URL}/orders", json=payload, headers=auth_headers)

    assert response.status_code == 400


def test_place_order_invalid_payment_data_returns_400(auth_headers):
    payload = {
        "items": VALID_ORDER_PAYLOAD["items"],
        "shipping": VALID_ORDER_PAYLOAD["shipping"],
        "payment": {**VALID_ORDER_PAYLOAD["payment"], "cardNumber": "1234"},
    }
    response = requests.post(f"{BASE_URL}/orders", json=payload, headers=auth_headers)

    assert response.status_code == 400


def test_place_order_no_auth_header_returns_401():
    response = requests.post(f"{BASE_URL}/orders", json=VALID_ORDER_PAYLOAD)

    assert response.status_code == 401


@pytest.mark.parametrize("quantity", [0, -1, -100])
def test_place_order_item_quantity_below_minimum_returns_400(auth_headers, quantity):
    payload = {
        "items": [{"productId": 1, "quantity": quantity}],
        "shipping": VALID_ORDER_PAYLOAD["shipping"],
        "payment": VALID_ORDER_PAYLOAD["payment"],
    }
    response = requests.post(f"{BASE_URL}/orders", json=payload, headers=auth_headers)

    assert response.status_code == 400
