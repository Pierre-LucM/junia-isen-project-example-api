from flask import Flask, jsonify
from azure.cosmos import CosmosClient, PartitionKey
from dotenv import load_dotenv, dotenv_values

# Flask app setup
app = Flask(__name__)

# Load environment variables
load_dotenv()

config = dotenv_values(".env")



@app.route("/")
def home():
    return jsonify({"message": "Welcome to the Shop API!"})


# Cosmos DB configuration
COSMOS_ENDPOINT = config["COSMOS_ENDPOINT"]
COSMOS_KEY = config["COSMOS_KEY"]
DATABASE_NAME = "taumedatabase"
ITEMS_CONTAINER = "items"
USERS_CONTAINER = "users"
BASKETS_CONTAINER = "baskets"

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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
