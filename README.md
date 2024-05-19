## User Story

### Epic: Deploy a Scalable API with a Secure Database on AWS EKS

**As a DevOps engineer, I want to deploy a scalable API with a secure database on AWS EKS, so that the API can handle high traffic while keeping the database secure from external access.**

#### User Stories

1. **Terraform Infrastructure Setup**
   - Create a VPC with public and private subnets.
   - Create an EKS cluster and associated node groups within the VPC.
   - Set up an RDS instance with security group rules that allow access only from the private subnets.

2. **Helm Charts for Kubernetes Resources**
   - Define Helm charts for the API, ingress controller, and database.
   - Deploy these resources using Helm.

3. **CI/CD Pipeline**
   - Implement a CI/CD pipeline using GitHub Actions to automate the deployment process.
   - Include a rollback mechanism in case of deployment failures.

4. **Monitoring and Logging**
   - Integrate monitoring using Prometheus and Grafana.
   - Set up log management using the ELK stack.
   - Configure alerts using Alertmanager to notify the team via Slack.

5. **Slack Integration for PR Approval**
   - Set up Slack notifications for pull request approvals and deployment statuses.
   - Ensure the team is notified of any issues or changes in the deployment.

### Tasks

1. **Set up Terraform configuration**:
   - Define the VPC, EKS, and RDS modules.
   - Create infrastructure resources using Terraform.

2. **Create Helm charts**:
   - Define Helm charts for the API, ingress controller, and database.
   - Deploy these resources to the EKS cluster.

3. **Implement CI/CD pipeline**:
   - Set up GitHub Actions for continuous integration and deployment.
   - Add Slack notifications for deployment statuses.

4. **Integrate monitoring and logging**:
   - Deploy Prometheus, Grafana, and the ELK stack using Helm.
   - Configure these tools to collect and visualize metrics and logs.

5. **Configure alerts**:
   - Set up alert rules in Prometheus.
   - Configure Alertmanager to send alerts to Slack or email.

6. **Test and verify the deployment**:
   - Ensure all resources are deployed correctly.
   - Verify that the API is accessible and the database is secure.
   - Check that monitoring, logging, and alerts are functioning as expected.

## How to Use

1. Clone the repository.
2. Configure AWS credentials.
3. Initialize and apply Terraform code.

    ```bash
    # Change directory to the infrastructure directory
    cd infrastructure

    # Initialize Terraform
    terraform init

    # Plan the Terraform deployment
    terraform plan

    # Apply the Terraform deployment
    terraform apply -auto-approve
    ```

4. Deploy Kubernetes resources using Helm.

    ```bash
    # Get the EKS cluster configuration
    aws eks --region us-west-2 update-kubeconfig --name my-eks-cluster

    # Change directory to the Helm charts directory
    cd ../helm/charts

    # Deploy the API
    helm upgrade --install api ./api --values ../values/dev-values.yaml

    # Deploy the Ingress Controller
    helm upgrade --install ingress-controller ./ingress-controller --values ../values/dev-values.yaml

    # Deploy the Database
    helm upgrade --install database ./database --values ../values/dev-values.yaml
    ```

5. Verify the deployment.

    ```bash
    # List all the pods to verify they are running
    kubectl get pods -A

    # Check the services to verify they are exposed correctly
    kubectl get svc -A

    # Get the ingress details to verify the API is accessible
    kubectl get ingress -A
    ```

### Testing Without an AWS Account

If you don't have access to an AWS account, you can use a local Kubernetes cluster such as Minikube, Kind, or Docker Desktop's Kubernetes support for testing purposes. Here's how you can set up and test with Minikube:

1. Start Minikube

    ```bash
    # Start Minikube
    minikube start

    # Point your shell to Minikube's Docker daemon
    eval $(minikube -p minikube docker-env)
    ```

2. Build and Deploy Locally

    ```bash
    # Build the Docker image locally
    docker build -t myapi:latest .

    # Change directory to the Helm charts directory
    cd helm/charts

    # Deploy the API
    helm upgrade --install api ./api --values ../values/dev-values.yaml

    # Deploy the Ingress Controller
    helm upgrade --install ingress-controller ./ingress-controller --values ../values/dev-values.yaml

    # Deploy the Database
    helm upgrade --install database ./database --values ../values/dev-values.yaml
    ```

3. Verify the Deployment

    ```bash
    # List all the pods to verify they are running
    kubectl get pods -A

    # Check the services to verify they are exposed correctly
    kubectl get svc -A

    # Get the ingress details to verify the API is accessible
    kubectl get ingress -A

    # To access the services locally
    minikube service list

    # To access the API
    minikube service <service-name> --url
    ```

### Next Steps

#### Jira Integration with Slack for PR Approval

To integrate with Slack for PR approvals and other notifications, you can use tools like Jenkins, GitHub Actions, or specific integrations provided by Slack. Here's an example using GitHub Actions and Slack:

#### GitHub Actions Workflow with Slack Notification

    ```yaml
    .github/workflows/ci-cd.yaml

    notify:
      run: ubuntu-latest
      needs: deploy
      steps:
        - name: Notify Slack
          if: always()
          uses: rtCamp/action-slack-notify@v2
          env:
            SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
          with:
            arguments: >
              {
                "channel": "#devops-notifications",
                "username": "github-actions",
                "text": "Deployment ${{ job.status }}: ${GITHUB_REPOSITORY}:${GITHUB_REF} - Job: ${{ github.workflow }}",
                "icon_emoji": ":rocket:"
              }

    reversal:
      run: ubuntu-latest
      needs: deploy
      if: failure()
      steps:
        - name: Checkout code
          uses: actions/checkout@v2

        - name: Configure Terraform
          uses: hashicorp/setup-terraform@v1
          with:
            terraform_version: 1.0.0

        - name: Terraform Initialization
          run: terraform init

        - name: Terraform Rollback
          run: terraform destroy -auto-approve
    ```

In this configuration, the notification job sends a Slack notification after the deployment job completes. Make sure to add the `SLACK_WEBHOOK` secret in your GitHub repository settings.

### Monitoring, Log Management, Alerts

1. **Monitoring with Prometheus and Grafana**
   - **Helm Charts:** Use Helm charts to deploy Prometheus and Grafana.
   - **Configuration:** Configure Prometheus to extract metrics from the API and other components.
   - **Dashboard:** Configure Grafana dashboards to visualize metrics.

2. **Log Management with ELK Stack (Elasticsearch, Logstash, Kibana)**
   - **Helm Charts:** Use Helm charts to deploy the ELK stack.
   - **Configuration:** Configure Logstash to collect logs from Kubernetes and send them to Elasticsearch.
   - **Dashboard:** Use Kibana to view and search logs.

3. **Alerts with Alertmanager**
   - **Integration:** Integrate Prometheus with Alertmanager.
   - **Setup:** Set up alert rules in Prometheus and configure Alertmanager to send alerts to Slack or email.