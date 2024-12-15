# Shop App API on Azure Cloud

This project demonstrates a simple Flask-based API deployed on Azure using Terraform. The infrastructure includes virtual networks, subnets, App Service, and CosmosDB, ensuring a secure, scalable, and organized deployment environment. Students will fork this repository for educational purposes.

### Key Features
- **Flask-based API** deployed as a containerized application.
- **Secure Infrastructure** with Azure Virtual Networks, private endpoints, and NAT Gateway.
- **Automated CI/CD Pipelines** using GitHub Actions.
- **NoSQL Database** powered by Azure CosmosDB with private access.
- **Swagger Documentation** for interactive API testing.

---

## Project Structure

- `api/`: Contains the Flask application code.
- `infrastructure/`: Contains Terraform scripts for provisioning Azure infrastructure.
- `.github/`: Contains GitHub Actions workflows for CI/CD pipelines.

---

## Prerequisites

- **Python 3.9 or later**: Ensures compatibility with Flask and required libraries.
- **Terraform 1.5 or later**: For provisioning Azure infrastructure.
- **Azure CLI**: Must be installed and configured to interact with Azure resources.
- **Docker**: Required for containerizing the Flask application.
- **Access to an Azure subscription**: To deploy and manage cloud resources.

**Tool Versions**:
- **Azure CLI**: Use version 2.50.0 or later to avoid compatibility issues.
- **Docker**: Version 24.x or later is recommended for smooth container builds.
- **Terraform**: Version 1.5 or higher for optimal support with Azure provider plugins.

---

## Configuring Terraform for Azure

1. Install Terraform:
   Follow the instructions at [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads).

2. Log in to Azure:
   ```bash
   az login
   ```

3. Set your Azure subscription:
   ```bash
   az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
   ```

4. Configure Terraform variables:
   Create a `terraform.tfvars` file in the `infrastructure/` directory:
   ```hcl
   subscription_id        = "<YOUR_AZURE_SUBSCRIPTION_ID>"

   acr_password           = "<AZURE_CONTAINER_REGISTRY_PASSWORD>"
   acr_client_id          = "<AZURE_CONTAINER_REGISTRY_CLIENT_ID>"

   new_relic_license_key  = "<NEW_RELIC_LICENSE_KEY>"
   new_relic_app_name     = "<NEW_RELIC_APP_NAME>"

   image_name             = "<DOCKER_IMAGE_NAME>"
   image_tag              = "<DOCKER_IMAGE_TAG>"
   ```

### Explanation of `terraform.tfvars` Variables

- `subscription_id`: Your Azure subscription ID. You can find it by running `az account show --query id -o tsv`.
- `acr_password` and `acr_client_id`: Credentials for your Azure Container Registry. You can retrieve these from the Azure portal under the ACR's Access keys section.
- `new_relic_license_key` and `new_relic_app_name`: Your New Relic license key and application name. These can be found in your New Relic account under Account settings.
- `image_name` and `image_tag`: The name and tag of the Docker image you will use for the Flask application.

### Monitoring the App on New Relic

1. Log in to your New Relic account.
2. Navigate to the APM (Application Performance Monitoring) section.
3. Find your application by the name specified in `new_relic_app_name`.
4. You can monitor various metrics such as response time, throughput, and error rates.

---

## Deploying the Infrastructure

1. **Initialize Terraform**:
   ```bash
   cd infrastructure/
   terraform init
   ```

2. **Plan Deployment**:
   ```bash
   terraform plan
   ```

3. **Apply Changes**:
   ```bash
   terraform apply
   ```
   Confirm with `yes` when prompted.

4. **Retrieve App Service URL**:
   Once deployed, run the following to fetch the endpoint:
   ```bash
   az webapp show --name "<WEB_APP_NAME>" --resource-group "<RESOURCE_GROUP_NAME>" --query defaultHostName -o tsv
   ```

   Example Output:
   ```plaintext
   https://<WEB_APP_NAME>.azurewebsites.net
   ```

---

## Terraform Infrastructure Overview

The Terraform configuration provisions the following Azure resources:

### 1. **Resource Group**
   - Central container to manage Azure resources.

### 2. **Virtual Network (VNet)**
   - A single VNet for isolating resources and enabling secure communication.

### 3. **Subnets**
   The VNet contains the following subnets:
   
   | Subnet Name        | Purpose                          | IP Range           |
   |--------------------|----------------------------------|--------------------|
   | `subnet_ip_gateway`| Hosts NAT Gateway and Public IP  | 10.0.0.0/28        |
   | `subnet_app`       | Dedicated to the App Service     | 10.0.1.0/24        |
   | `subnet_db`        | Reserved for Azure CosmosDB      | 10.0.2.0/24        |

### 4. **NAT Gateway & Public IP**
   - Manages all outbound traffic for secure internet communication.

### 5. **Azure CosmosDB**
   - NoSQL database with private endpoint enabled for VNet integration. CosmosDB is not publicly accessible.

### 6. **Azure Container Registry (ACR)**
   - Stores container images built for the Flask application.

### 7. **Azure App Service (Linux Plan)**
   - Hosts the Flask application as a container.
   - Configured to integrate with the `subnet_app` for secure VNet access.

### 8. **Private Endpoints**
   - Ensures that CosmosDB and other resources are accessible only within the VNet.

**Why These Resources Were Chosen**:
- **Resource Group**: Provides a logical boundary for managing resources efficiently.
- **Virtual Network and Subnets**: Isolate resources to improve security and control traffic flow.
- **Azure CosmosDB**: Chosen for its scalable, managed NoSQL capabilities and VNet integration.
- **Azure App Service**: Simplifies deployment of containerized applications and ensures scalability.
- **NAT Gateway**: Centralizes outbound internet access for enhanced security and cost-efficiency.
- **Private Endpoints**: Ensures sensitive resources (like CosmosDB) are not exposed to the public internet.

---

## Application Features

This API provides several endpoints for managing users, items, and baskets:

### 1. **Clear Database Endpoint**
- **Path**: `/clear`
- **Method**: `DELETE`
- **Description**: Deletes all items from all containers.

### 2. **Users Endpoints**
- **Retrieve all users**:
  - **Path**: `/users`
  - **Method**: `GET`
  - **Description**: Retrieves a list of all users.
- **Add a new user**:
  - **Path**: `/users`
  - **Method**: `POST`
  - **Description**: Adds a new user to the database.

### 3. **Items Endpoints**
- **Retrieve all items**:
  - **Path**: `/items`
  - **Method**: `GET`
  - **Description**: Retrieves a list of all items.
- **Add a new item**:
  - **Path**: `/items`
  - **Method**: `POST`
  - **Description**: Adds a new item to the database.

### 4. **Baskets Endpoints**
- **Retrieve all baskets**:
  - **Path**: `/baskets`
  - **Method**: `GET`
  - **Description**: Retrieves a list of all baskets.
- **Add a new basket**:
  - **Path**: `/baskets`
  - **Method**: `POST`
  - **Description**: Adds a new basket to the database.
- **Retrieve a basket by user ID**:
  - **Path**: `/baskets/<user_id>`
  - **Method**: `GET`
  - **Description**: Retrieves a basket by the specified user ID.

### 5. **Swagger Documentation**
The application includes Swagger UI for interactive API testing and documentation.

- **Access**: Navigate to the root endpoint `/`.
- **Features**:
   - Test all available endpoints.
   - View request/response schemas.
   - Easily interact with the API using built-in forms.

To test the API:
1. Deploy the infrastructure and run the application.
2. Access the Swagger UI at the root endpoint (e.g., `https://<WEB_APP_NAME>.azurewebsites.net`).
3. Use the interactive forms to send requests to various endpoints and verify responses.

---

## Clean Up

To destroy all resources and prevent additional charges:
```bash
terraform destroy
```
Confirm with `yes` when prompted.

---