<!DOCTYPE html>
<html>
<body>

<h1>Capstone Infrastructure Deployment</h1>

<h2>Overview</h2>
<p>The infrastructure for the <strong>Capstone Application</strong> is deployed on <strong>AWS ECS (Fargate)</strong> using <strong>Terraform</strong>. The deployment is fully automated via <strong>GitHub Actions</strong>, with separate environments for staging and production.</p>

<h3>Deployment Environments</h3>
<ul>
    <li><strong>Staging</strong> - Used for testing and validation before going live.</li>
    <li><strong>Production</strong> - Live environment for end users (requires manual approval).</li>
</ul>

<h2>Architecture</h2>
<h3>Key Components</h3>
<ul>
    <li>✅ <strong>AWS ECS (Fargate)</strong> - Serverless container management.</li>
    <li>✅ <strong>Amazon ECR</strong> - Stores container images.</li>
    <li>✅ <strong>DynamoDB</strong> - NoSQL database for persistent storage.</li>
    <li>✅ <strong>VPC & Security Groups</strong> - Secure networking setup.</li>
    <li>✅ <strong>Terraform</strong> - Manages infrastructure as code.</li>
</ul>

<h2>GitHub Actions Workflow</h2>
<h3>Infrastructure Deployment</h3>
<p>Deployments are automated via GitHub Actions.</p>
<ul>
    <li><strong>Staging:</strong> Automatically deployed when changes are pushed to the repository.</li>
    <li><strong>Production:</strong> Requires manual approval before deployment.</li>
</ul>

<h3>Triggering a Deployment</h3>
<p>The workflow can be triggered in three ways:</p>
<ol>
    <li>Automatically on a push to the <strong>main</strong> branch.</li>
    <li>On a pull request targeting the <strong>main</strong> branch.</li>
    <li>Manually via GitHub Actions using the <strong>workflow_dispatch</strong> event.</li>
</ol>

<h3>Infrastructure Workflow</h3>
<pre>
terraform init
terraform plan -var="environment=staging"  # Change to "production" for production
terraform apply -var="environment=staging" -auto-approve
</pre>

<h2>Destroy Infrastructure</h2>
<p>To remove resources, use Terraform destroy:</p>

<h3>Staging Environment</h3>
<ul>
    <li>✅ Can be destroyed automatically if needed.</li>
    <li>✅ Triggered manually via GitHub Actions.</li>
</ul>
<pre>terraform destroy -var="environment=staging" -auto-approve</pre>

<h3>Production Environment</h3>
<ul>
    <li>🔒 <strong>Requires manual approval.</strong></li>
    <li>✅ Triggered manually via GitHub Actions.</li>
</ul>
<pre>terraform destroy -var="environment=production"</pre>

<h2>Environment Variables</h2>
<p>These Terraform variables must be configured for deployment:</p>
<pre>
TF_VAR_ENVIRONMENT=staging  # or "production"
TF_VAR_ECS_CLUSTER_NAME=ecs-cluster-name
TF_VAR_ECS_SERVICE_NAME=ecs-service-name
TF_VAR_ECS_TASK_FAMILY=ecs-task-family
TF_VAR_DYNAMODB_TABLE_NAME=dynamodb-table
</pre>

<h2>Terraform Outputs</h2>
<table border="1">
    <tr>
        <th>Output Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><strong>ECS Cluster Name</strong></td>
        <td>Name of the deployed ECS cluster.</td>
    </tr>
    <tr>
        <td><strong>ECS Task Family</strong></td>
        <td>Family of the ECS task definition.</td>
    </tr>
    <tr>
        <td><strong>ECS Service Name</strong></td>
        <td>Name of the deployed ECS service.</td>
    </tr>
    <tr>
        <td><strong>DynamoDB Table</strong></td>
        <td>Name of the associated DynamoDB table.</td>
    </tr>
    <tr>
        <td><strong>ECR Repository</strong></td>
        <td>Name of the container registry.</td>
    </tr>
</table>

<h2>Future Enhancements</h2>
<ul>
    <li>🔹 <strong>Application Load Balancer (ALB)</strong> - For improved routing and security.</li>
    <li>🔹 <strong>Autoscaling</strong> - Adjust ECS tasks dynamically.</li>
    <li>🔹 <strong>Logging & Monitoring</strong> - CloudWatch or Prometheus integration.</li>
    <li>🔹 <strong>Full CI/CD Pipeline</strong> - Automate deployments with GitHub Actions.</li>
</ul>

<h2>Notes</h2>
<ul>
    <li>Ensure <strong>AWS credentials</strong> are set up before running Terraform.</li>
    <li>Modify <strong>security group</strong> settings for better security.</li>
    <li>Adjust <strong>desired_count</strong> based on deployment needs.</li>
</ul>

<h2>License</h2>
<p>MIT License</p>

</body>
</html>
