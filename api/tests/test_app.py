import pytest
from api.app import app
from unittest.mock import patch


@pytest.fixture
def client():
    app.testing = True
    with app.test_client() as client:
        yield client


def test_home(client):
    response = client.get("/")
    assert response.status_code == 200


def test_get_users(client):
    mock_users = [
        {"id": "1", "name": "User One"},
        {"id": "2", "name": "User Two"}
    ]
    with patch('api.app.users_container.query_items') as mock_query:
        mock_query.return_value = iter(mock_users)
        response = client.get('/users')
        assert response.status_code == 200
        assert response.get_json() == mock_users


def test_add_user(client):
    new_user = {
        "id": "3",
        "user_id": "user123",
        "name": "John Doe"
    }
    with patch('api.app.users_container.upsert_item') as mock_upsert:
        response = client.post('/users', json=new_user)
        assert response.status_code == 200
        assert response.get_json() == {
            "message": "User added successfully",
            "user": new_user
        }
        mock_upsert.assert_called_once_with(new_user)


def test_get_items(client):
    mock_items = [
        {"id": "1", "name": "Item One", "category": "Category A", "price": 9.99},
        {"id": "2", "name": "Item Two", "category": "Category B", "price": 19.99}
    ]
    with patch('api.app.items_container.query_items') as mock_query:
        mock_query.return_value = iter(mock_items)
        response = client.get('/items')
        assert response.status_code == 200
        assert response.get_json() == mock_items


def test_add_item(client):
    new_item = {
        "id": "3",
        "name": "Item Three",
        "category": "Category C",
        "price": 29.99
    }
    with patch('api.app.items_container.upsert_item') as mock_upsert:
        response = client.post('/items', json=new_item)
        assert response.status_code == 200
        assert response.get_json() == {
            "message": "Item added successfully",
            "item": new_item
        }
        mock_upsert.assert_called_once_with(new_item)


def test_get_baskets(client):
    mock_baskets = [
        {"id": "1", "user_id": "user123", "items": [{"item_id": "123", "quantity": 2}]},
        {"id": "2", "user_id": "user456", "items": [{"item_id": "456", "quantity": 1}]}
    ]
    with patch('api.app.baskets_container.query_items') as mock_query:
        mock_query.return_value = iter(mock_baskets)
        response = client.get('/baskets')
        assert response.status_code == 200
        assert response.get_json() == mock_baskets


def test_add_basket(client):
    new_basket = {
        "id": "3",
        "user_id": "user789",
        "items": [
            {"item_id": "789", "quantity": 3},
            {"item_id": "101", "quantity": 1}
        ]
    }
    with patch('api.app.baskets_container.upsert_item') as mock_upsert:
        response = client.post('/baskets', json=new_basket)
        assert response.status_code == 200
        assert response.get_json() == {
            "message": "Basket added successfully",
            "basket": new_basket
        }
        mock_upsert.assert_called_once_with(new_basket)


def test_get_basket(client):
    user_id = "user123"
    mock_basket = [
        {"id": "1", "user_id": "user123", "items": [{"item_id": "123", "quantity": 2}]}
    ]
    with patch('api.app.baskets_container.query_items') as mock_query:
        mock_query.return_value = iter(mock_basket)
        response = client.get(f'/baskets/{user_id}')
        assert response.status_code == 200
        assert response.get_json() == mock_basket


def test_clear_containers(client):
    mock_items = [
        {"id": "1", "category": "Category A"},
        {"id": "2", "category": "Category B"}
    ]
    mock_users = [
        {"id": "1", "user_id": "user123"},
        {"id": "2", "user_id": "user456"}
    ]
    mock_baskets = [
        {"id": "1", "user_id": "user123"},
        {"id": "2", "user_id": "user456"}
    ]

    with patch('api.app.items_container.query_items') as mock_query_items, \
         patch('api.app.items_container.delete_item') as mock_delete_item, \
         patch('api.app.users_container.query_items') as mock_query_users, \
         patch('api.app.users_container.delete_item') as mock_delete_user, \
         patch('api.app.baskets_container.query_items') as mock_query_baskets, \
         patch('api.app.baskets_container.delete_item') as mock_delete_basket:

        mock_query_items.return_value = iter(mock_items)
        mock_query_users.return_value = iter(mock_users)
        mock_query_baskets.return_value = iter(mock_baskets)

        response = client.delete('/clear')
        assert response.status_code == 200
        assert response.get_json() == {"message": "All containers have been cleared."}

        # Verify delete_item was called for items
        assert mock_delete_item.call_count == len(mock_items)
        for item in mock_items:
            mock_delete_item.assert_any_call(item, partition_key=item['category'])

        # Verify delete_item was called for users
        assert mock_delete_user.call_count == len(mock_users)
        for user in mock_users:
            mock_delete_user.assert_any_call(user, partition_key=user['user_id'])

        # Verify delete_item was called for baskets
        assert mock_delete_basket.call_count == len(mock_baskets)
        for basket in mock_baskets:
            mock_delete_basket.assert_any_call(basket, partition_key=basket['user_id'])
