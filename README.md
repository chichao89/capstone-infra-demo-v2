<!DOCTYPE html>
<html>
<head>
    <title>Capstone RegisterApp - Infrastructure</title>
</head>
<body>

<h1>Capstone RegisterApp - Infrastructure</h1>

<h2>Overview</h2>
<p>The <strong>Capstone RegisterApp</strong> is a web application built using Flask, containerized with Docker, and deployed on <strong>AWS ECS (Fargate)</strong>. The infrastructure is managed using <strong>Terraform</strong>, ensuring automated and scalable deployments.</p>

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
    <li>✅ <strong>Terraform Workspaces</strong> - Dynamic environment selection</li>
</ul>

<h3>Infrastructure Flow</h3>
<ol>
    <li><strong>Build & Push Image</strong> - The Flask app is built into a <strong>Docker image</strong> and uploaded to <strong>Amazon ECR</strong></li>
    <li><strong>Provision Infrastructure</strong> - Terraform provisions AWS resources for ECS, networking, and security</li>
    <li><strong>Deploy to ECS</strong> - The container is deployed to <strong>AWS ECS (Fargate)</strong> in the selected environment</li>
    <li><strong>Application Access</strong> - The service runs within a private <strong>VPC</strong>, accessible via its assigned public IP</li>
</ol>

<h2>Prerequisites</h2>
<ul>
    <li>✅ <strong>Terraform ≥ 0.12</strong></li>
    <li>✅ <strong>AWS Account</strong> with IAM permissions</li>
    <li>✅ <strong>AWS CLI</strong> configured with appropriate credentials</li>
</ul>

<h3>Setup AWS Environment Secrets</h3>
<p>Set the following <strong>secrets</strong> in your environment (e.g., GitHub Actions or local <code>.env</code> file):</p>
<pre>
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
</pre>

<h3>Environment Variables for Terraform</h3>
<p>Set these <strong>Terraform variables</strong> as environment variables before running deployments:</p>
<pre>
TF_VAR_DYNAMODB_TABLE_NAME=your-dynamodb-table
TF_VAR_ECS_CLUSTER_NAME=your-ecs-cluster-name
TF_VAR_ECS_SERVICE_NAME=your-ecs-service-name
TF_VAR_ECS_TASK_FAMILY=your-ecs-task-family
TF_VAR_ENVIRONMENT=staging  # or "production"
</pre>

<h2>Deployment Workflow</h2>
<ol>
    <li><strong>Initialize Terraform</strong>
        <pre>terraform init</pre>
    </li>
    <li><strong>Select or Create a Workspace</strong>
        <pre>terraform workspace select &lt;environment&gt; || terraform workspace new &lt;environment&gt;</pre>
    </li>
    <li><strong>Plan the Deployment</strong>
        <pre>terraform plan -var="environment=staging"  # Change "staging" to "production" if needed</pre>
    </li>
    <li><strong>Apply the Configuration</strong>
        <pre>terraform apply -var="environment=staging" -auto-approve</pre>
    </li>
    <li><strong>Destroy Resources (if needed)</strong>
        <pre>terraform destroy -var="environment=staging" -auto-approve</pre>
    </li>
</ol>

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
    <li>🔹 <strong>CI/CD Pipeline</strong> - Automate deployments with GitHub Actions or AWS CodePipeline</li>
</ul>

<h2>Notes</h2>
<ul>
    <li>Ensure <strong>AWS credentials</strong> are set up before running Terraform</li>
    <li>Modify <strong>security group</strong> settings for production security</li>
    <li>Adjust <strong>desired_count</strong> based on deployment needs</li>
</ul>

<h2>License</h2>
<p>MIT License</p>

<h2>Final Thoughts</h2>
<p>This <strong>README</strong> provides a <strong>clear, structured</strong> guide for deploying your Flask app on AWS ECS using Terraform.</p>

</body>
</html>


