<!DOCTYPE html>
<html>
<body>

<h1>Capstone RegisterApp - Infrastructure</h1>

<h2>Overview</h2>
<p>The <strong>Capstone RegisterApp</strong> is a web application built using Flask, containerized with Docker, and deployed on <strong>AWS ECS (Fargate)</strong>. The infrastructure is managed using <strong>Terraform</strong> and automated via <strong>GitHub Actions</strong> for continuous deployment.</p>

<h3>Deployment Environments</h3>
<ul>
    <li><strong>Staging</strong> - For testing and validation</li>
    <li><strong>Production</strong> - Live application for end users</li>
</ul>

<h2>Architecture</h2>
<h3>Key Components</h3>
<ul>
    <li>✅ <strong>Flask Web Application</strong> - Python-based backend handling requests</li>
    <li>✅ <strong>Docker Containerization</strong> - Packaged and stored in <strong>Amazon ECR</strong></li>
    <li>✅ <strong>AWS ECS (Fargate)</strong> - Serverless container management</li>
    <li>✅ <strong>VPC & Security Groups</strong> - Secure networking & traffic control</li>
    <li>✅ <strong>DynamoDB</strong> - NoSQL database for persistence</li>
</ul>

<h3>Infrastructure Flow</h3>
<ol>
    <li><strong>Build & Push Image</strong> - The Flask app is built into a <strong>Docker image</strong> and uploaded to <strong>Amazon ECR</strong></li>
    <li><strong>Provision Infrastructure</strong> - Terraform provisions AWS resources for ECS, networking, and security</li>
    <li><strong>Deploy to ECS</strong> - The container is deployed to <strong>AWS ECS (Fargate)</strong> in the selected environment</li>
    <li><strong>Application Access</strong> - The service runs within a private <strong>VPC</strong>, accessible via its assigned public IP</li>
</ol>

<h2>GitHub Actions Workflow</h2>
<p>All deployments and infrastructure changes are managed through <strong>GitHub Actions</strong>, removing the need for manual Terraform CLI execution.</p>

<h3>Available Workflows</h3>
<ul>
    <li>🔹 <strong>Terraform Apply</strong> - Deploys the infrastructure and application.</li>
    <li>🔹 <strong>Terraform Destroy</strong> - Destroys the infrastructure for a selected environment.</li>
</ul>

<h3>Triggering a Deployment</h3>
<p>To deploy the application via GitHub Actions:</p>
<ol>
    <li>Navigate to <strong>GitHub Repository → Actions → Terraform Apply</strong></li>
    <li>Click <strong>"Run Workflow"</strong></li>
    <li>Select an environment (<strong>staging</strong> or <strong>production</strong>)</li>
    <li>Click <strong>"Run"</strong> to start deployment</li>
</ol>

<h3>Destroying Resources</h3>
<p>To remove the infrastructure:</p>
<ol>
    <li>Navigate to <strong>GitHub Repository → Actions → Terraform Destroy</strong></li>
    <li>Click <strong>"Run Workflow"</strong></li>
    <li>Select an environment (<strong>staging</strong> or <strong>production</strong>)</li>
    <li>Click <strong>"Run"</strong> to start deletion</li>
</ol>

<h2>Environment Variables</h2>
<p>The deployment workflow uses environment variables instead of Terraform workspaces.</p>
<p>Set these in your GitHub repository secrets or local environment:</p>
<pre>
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
TF_VAR_DYNAMODB_TABLE_NAME=your-dynamodb-table
TF_VAR_ECS_CLUSTER_NAME=your-ecs-cluster-name
TF_VAR_ECS_SERVICE_NAME=your-ecs-service-name
TF_VAR_ECS_TASK_FAMILY=your-ecs-task-family
TF_VAR_ENVIRONMENT=staging  # or "production"
</pre>

<h2>Outputs</h2>
<table border="1">
    <tr>
        <th>Output Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><strong>ECS Cluster Name</strong></td>
        <td>Name of the deployed ECS cluster</td>
    </tr>
    <tr>
        <td><strong>ECS Task Family</strong></td>
        <td>Family of the ECS task definition</td>
    </tr>
    <tr>
        <td><strong>ECS Service Name</strong></td>
        <td>Name of the deployed ECS service</td>
    </tr>
    <tr>
        <td><strong>DynamoDB Table</strong></td>
        <td>Name of the associated DynamoDB table</td>
    </tr>
    <tr>
        <td><strong>Container Name</strong></td>
        <td>Name of the running container</td>
    </tr>
    <tr>
        <td><strong>Task Definition ARN</strong></td>
        <td>ARN of the ECS task definition</td>
    </tr>
    <tr>
        <td><strong>ECS Service ARN</strong></td>
        <td>ARN of the ECS service</td>
    </tr>
    <tr>
        <td><strong>ECR Repository</strong></td>
        <td>Name of the shared ECR repository</td>
    </tr>
</table>

<h2>Terraform Variables</h2>
<table border="1">
    <tr>
        <th>Variable Name</th>
        <th>Description</th>
        <th>Type</th>
        <th>Default Value</th>
    </tr>
    <tr>
        <td>ecs_cluster_name</td>
        <td>Name of the ECS cluster</td>
        <td>string</td>
        <td>-</td>
    </tr>
    <tr>
        <td>ecs_task_family</td>
        <td>ECS task definition family</td>
        <td>string</td>
        <td>-</td>
    </tr>
    <tr>
        <td>ecs_service_name</td>
        <td>ECS service name</td>
        <td>string</td>
        <td>-</td>
    </tr>
    <tr>
        <td>environment</td>
        <td>Deployment environment (staging/production)</td>
        <td>string</td>
        <td>-</td>
    </tr>
    <tr>
        <td>dynamodb_table_name</td>
        <td>DynamoDB table name</td>
        <td>string</td>
        <td>-</td>
    </tr>
</table>

<h2>Future Enhancements</h2>
<ul>
    <li>🔹 <strong>Application Load Balancer (ALB)</strong> - Improve routing and security</li>
    <li>🔹 <strong>Autoscaling</strong> - Dynamically adjust ECS tasks based on traffic</li>
    <li>🔹 <strong>Monitoring & Logging</strong> - Implement CloudWatch or Prometheus for better observability</li>
    <li>🔹 <strong>CI/CD Enhancements</strong> - Extend GitHub Actions for blue/green deployments</li>
</ul>

<h2>License</h2>
<p>MIT License</p>

<h2>Final Thoughts</h2>
<p>This <strong>README</strong> now reflects an automated GitHub Actions-based infrastructure deployment, making Terraform commands unnecessary.</p>

</body>
</html>
