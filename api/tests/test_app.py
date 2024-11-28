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
