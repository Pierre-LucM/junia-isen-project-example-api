from flask import Flask, jsonify, request
from azure.cosmos import CosmosClient, PartitionKey
from dotenv import load_dotenv, dotenv_values
from flasgger import Swagger

# Flask app setup
app = Flask(__name__)

# Load environment variables
load_dotenv()

config = dotenv_values(".env")

# Cosmos DB configuration
COSMOS_ENDPOINT = config["COSMOS_ENDPOINT"]
COSMOS_KEY = config["COSMOS_KEY"]
DATABASE_NAME = "taumedatabase"
ITEMS_CONTAINER = "items"
USERS_CONTAINER = "users"
BASKETS_CONTAINER = "baskets"

app.config['SWAGGER'] = {
    'title': 'Shop WebApp API',
    'version': '0.1.0',
    'description': 'API documentation for the Shop WebApp, providing endpoints for items, users, and baskets.',
    'specs_route': '/',
}

swagger_template = {
    "swagger": "2.0",
    "info": {
        "title": "Shop WebApp API",
        "description": "API documentation for the Shop WebApp, providing endpoints for items, users, and baskets.",
        "version": "0.1.0"
    },
    "tags": [
        {"name": "Users", },
        {"name": "Items", },
        {"name": "Baskets", },
        {"name": "Clear Database", },
    ],
}
swagger = Swagger(app, template=swagger_template)

# Validate environment variables
if not COSMOS_ENDPOINT or not COSMOS_KEY:
    raise ValueError("COSMOS_ENDPOINT and COSMOS_KEY must be set in the .env file")

# Cosmos DB client and database
client = CosmosClient(COSMOS_ENDPOINT, COSMOS_KEY)
database = client.create_database_if_not_exists(DATABASE_NAME)

# Create containers
items_container = database.create_container_if_not_exists(
    id=ITEMS_CONTAINER,
    partition_key=PartitionKey(path="/category"),
    offer_throughput=400
)
users_container = database.create_container_if_not_exists(
    id=USERS_CONTAINER,
    partition_key=PartitionKey(path="/user_id"),
    offer_throughput=400
)
baskets_container = database.create_container_if_not_exists(
    id=BASKETS_CONTAINER,
    partition_key=PartitionKey(path="/user_id"),
    offer_throughput=400
)

# Get Users route


@app.route('/users', methods=['GET'])
def get_users():
    """
    Retrieve all users.
    ---
    tags:
      - "Users"
    responses:
      200:
        description: List of users
    """
    query = "SELECT * FROM users"
    users = list(users_container.query_items(query=query, enable_cross_partition_query=True))
    return jsonify(users)

# Create User route


@app.route('/users', methods=['POST'])
def add_user():
    """
    Add a new user.
    ---
    tags:
      - "Users"
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          properties:
            id:
              type: string
              example: "456"
            user_id:
              type: string
              example: "user123"
            name:
              type: string
              example: "John Doe"
    responses:
      200:
        description: User added successfully
    """
    data = request.get_json()
    users_container.upsert_item(data)
    return jsonify({"message": "User added successfully", "user": data}), 200


# Run the app
if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
