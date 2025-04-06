<!DOCTYPE html>
<html>
<body>

<!-- Title and Team -->
<h1 align="center">🚀 Capstone Infrastructure Deployment (CI/CD Pipeline Focused)</h1>

<h2>Team Members</h2>
<ul>
    <li>Cornelia</li>
    <li>Thila</li>
    <li>Shakeela</li>
    <li>Chi Chao</li>
    <li>Linus</li>
</ul>

<!-- Overview -->
<h2>Overview</h2>
<p>
  The infrastructure for the <strong>Capstone Application</strong> is deployed on <strong>AWS ECS (Fargate)</strong> using <strong>Terraform</strong>. 
  The deployment is fully automated via <strong>GitHub Actions</strong>, supporting separate environments for staging (automated) and production (manual approval).
</p>

<!-- Why This Design (Startup Focus) -->
<h2>Why This Design?</h2>
<h3>Startup Use Case Alignment</h3>
<p><em>A fast-growing startup needs a scalable DevOps workflow to:</em></p>
<ul>
    <li>🚀 Accelerate releases from development to staging to production.</li>
    <li>🔐 Enforce code reviews and branch permissions as the team grows.</li>
    <li>⚡ Ensure consistency across environments using Infrastructure-as-Code (IaC).</li>
</ul>
<table border="1">
    <tr>
        <th>Design Choice</th>
        <th>Why It Fits the Startup</th>
    </tr>
    <tr>
        <td><strong>GitHub Actions Automation</strong></td>
        <td>✅ Native CI/CD integration with branch protections and scalability.</td>
    </tr>
    <tr>
        <td><strong>Terraform + Variables</strong></td>
        <td>✅ DRY code for dev, staging, and production ensuring environment consistency.</td>
    </tr>
    <tr>
        <td><strong>AWS Fargate (Serverless)</strong></td>
        <td>✅ No EC2 management, auto-scaling with user growth.</td>
    </tr>
    <tr>
        <td><strong>Manual Production Approval</strong></td>
        <td>🔒 Controlled, deliberate production releases.</td>
    </tr>
</table>

<!-- Prerequisites -->
<h2>Prerequisites</h2>
<ul>
    <li>AWS Account with necessary IAM permissions (ECS, ECR, DynamoDB, VPC).</li>
    <li>Terraform ≥ 1.0</li>
    <li>GitHub Secrets configured:
        <ul>
            <li><code>AWS_ACCESS_KEY_ID</code></li>
            <li><code>AWS_SECRET_ACCESS_KEY</code></li>
            <li><code>S3_BUCKET</code> (for Terraform remote state)</li>
        </ul>
    </li>
</ul>

<!-- Branching Strategy & Permissions -->
<h2>Branching Strategy & Permissions</h2>
<pre>
graph LR
    A[Feature Branch] -->|PR + 2 Reviews| B(main)
    B -->|Auto-Deploy| C[Staging]
    C -->|Manual Approval| D[Production]
</pre>
<table border="1">
    <tr>
        <th>Branch</th>
        <th>Permissions</th>
    </tr>
    <tr>
        <td><code>main</code></td>
        <td>✅ PR required with 2 approvals and Terraform plan check</td>
    </tr>
    <tr>
        <td><code>production</code></td>
        <td>🔒 Merge only by DevOps team</td>
    </tr>
</table>

<!-- Architecture -->
<h2>Architecture</h2>
<h3>Key Components (Implemented)</h3>
<ul>
    <li>✅ <strong>AWS ECS (Fargate)</strong> - Serverless container orchestration.</li>
    <li>✅ <strong>Amazon ECR</strong> - Stores container images (Repository: <code>group2-register-service-ecr-repo</code>).</li>
    <li>✅ <strong>DynamoDB</strong> - NoSQL database for persistent storage (Table: <code>users</code>).</li>
    <li>✅ <strong>VPC & Security Groups</strong> - Custom networking with public/private subnets.</li>
    <li>✅ <strong>Application Load Balancer (ALB)</strong> - Traffic routing and security (Name: <code>app-alb</code>). Also uses a target group (<code>ecs-target-group</code>).</li>
    <li>✅ <strong>Terraform</strong> - Infrastructure as Code for environment parity.</li>
    <li>✅ <strong>CloudWatch</strong> - Integrated for monitoring and logging.</li>
    <li>✅ <strong>GitHub Actions</strong> - CI/CD automation for rapid and controlled releases.</li>
</ul>
<h3>Network Design</h3>
<ul>
    <li>VPC with public/private subnets across 2 AZs.</li>
    <li>ECS tasks run in private subnets while the ALB is placed in public subnets.</li>
    <li>Security groups ensure that only ALB traffic reaches ECS tasks.</li>
</ul>

<!-- GitHub Actions Workflow -->
<h2>GitHub Actions Workflow</h2>
<h3>Staging Deployment (Automated)</h3>
<pre>
name: Deploy to Staging
on:
  push:
    branches: [main]
jobs:
  deploy:
    steps:
      - name: Terraform Init & Plan
        run: terraform plan -var="environment=staging"
      - name: Terraform Apply
        run: terraform apply -var="environment=staging" -auto-approve
</pre>

<h3>Production Deployment (Manual Approval)</h3>
<pre>
name: Deploy to Production
on:
  workflow_dispatch:
jobs:
  deploy:
    steps:
      - name: Terraform Init & Plan
        run: terraform plan -var="environment=production"
      - name: Await Manual Approval
        run: echo "Manual approval required..."
      - name: Terraform Apply
        run: terraform apply -var="environment=production" -auto-approve
</pre>

<!-- Terraform Configuration -->
<h2>Terraform Configuration</h2>
<h3>Environment Variables</h3>
<pre>
TF_VAR_ENVIRONMENT=staging         # or "production"
TF_VAR_ECS_CLUSTER_NAME="ecs-cluster"
TF_VAR_ECS_SERVICE_NAME="ecs-service"
TF_VAR_ECS_TASK_FAMILY="ecs-task"
TF_VAR_DYNAMODB_TABLE_NAME="users"
TF_VAR_ECR_REPOSITORY="group2-register-service-ecr-repo"
TF_VAR_ALB_NAME="app-alb"
TF_VAR_TARGET_GROUP_NAME="ecs-target-group"
</pre>

<h3>Terraform Outputs</h3>
<table border="1">
    <tr>
        <th>Output</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><code>alb_dns_name</code></td>
        <td>ALB endpoint URL</td>
    </tr>
    <tr>
        <td><code>ecs_service_arn</code></td>
        <td>ECS Service ARN</td>
    </tr>
    <tr>
        <td><code>ecs_cluster_name</code></td>
        <td>Name of the deployed ECS cluster</td>
    </tr>
    <tr>
        <td><code>ecs_task_family</code></td>
        <td>ECS Task Definition Family</td>
    </tr>
    <tr>
        <td><code>dynamodb_table_name</code></td>
        <td>Name of the DynamoDB table</td>
    </tr>
    <tr>
        <td><code>ecr_repository</code></td>
        <td>Container registry name</td>
    </tr>
    <tr>
        <td><code>target_group_name</code></td>
        <td>Name of the ECS target group</td>
    </tr>
</table>

<!-- Destroying Infrastructure -->
<h2>Destroy Infrastructure</h2>
<p>To remove resources, use Terraform destroy:</p>

<h3>Staging Environment</h3>
<ul>
    <li>✅ Can be destroyed automatically if needed.</li>
    <li>✅ Triggered manually via GitHub Actions.</li>
</ul>
<pre>
terraform destroy -var="environment=staging" -auto-approve
</pre>

<h3>Production Environment</h3>
<ul>
    <li>🔒 Requires manual approval.</li>
    <li>✅ Triggered manually via GitHub Actions.</li>
</ul>
<pre>
terraform destroy -var="environment=production"
</pre>

<!-- Future Enhancements -->
<h2>Future Enhancements</h2>
<ul>
    <li>🔹 <strong>Autoscaling</strong> - Adjust ECS tasks dynamically based on load.</li>
    <li>🔹 <strong>Full CI/CD Pipeline</strong> - Further automate application deployments.</li>
    <li>🔹 <strong>Enhanced Observability</strong> - Integrate additional monitoring tools and dashboards.</li>
    <li>🔹 <strong>Security Hardening</strong> - Further refine IAM roles and security group configurations.</li>
</ul>

<!-- Security, Developer Workflow, and Troubleshooting -->
<h2>Security</h2>
<ul>
    <li>🔐 IAM roles follow least privilege; ECS tasks cannot modify infrastructure.</li>
    <li>🔒 Security groups restrict access to only allow ALB → ECS traffic.</li>
    <li>🔑 Secrets are stored securely in GitHub Secrets (never in code).</li>
</ul>

<h2>Developer Workflow</h2>
<ol>
    <li>Clone the repository: <code>git clone https://github.com/naoruki/capstone_webapp_group2_v2</code></li>
    <li>Create a feature branch: <code>git checkout -b feat/new-feature</code></li>
    <li>Push changes and open a pull request to <code>main</code></li>
    <li>After receiving 2 approvals, the PR is merged and auto-deployed to staging.</li>
</ol>

<h2>Troubleshooting</h2>
<ul>
    <li>🔍 <strong>ECS Task Failures:</strong> Check CloudWatch logs at <code>/ecs/${var.ecs_task_family}</code></li>
    <li>🔧 <strong>ALB Health Checks:</strong> Ensure the <code>/health</code> endpoint returns HTTP 200</li>
</ul>

<!-- Web App Link -->
<h2>Web App Link</h2>
<p><a href="https://github.com/naoruki/capstone_webapp_group2_v2" target="_blank">https://github.com/naoruki/capstone_webapp_group2_v2</a></p>

</body>
</html>
