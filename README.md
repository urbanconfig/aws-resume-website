# Resume Website on AWS

### My website can be accessed at: https://karolurban.com

## 🚀 Project Overview

This repository contains all files required for deploying my personal static resume website. The project is hosted entirely on **Amazon Web Services (AWS)** using a serverless architecture for low maintenance, and cost efficiency. The infrastructure is provisioned and managed using **Terraform**, and the entire deployment process is automated via continuous integration and continuous deployment (CI/CD) pipeline built with **GitHub Actions**. The website utilizes a modern static-site hosting pattern combined with a Content Delivery Network (CDN) to ensure fast load times and global reach.

---

### Architecture Diagram




## 🛠️ Technologies Used

### ☁️ AWS Services

1.  **S3 Bucket:** The raw website files (HTML, CSS, JS) are stored in a private S3 Bucket. CloudFront is configured to serve content exclusively from this S3 bucket, preventing direct public access.
2.  **CloudFront (CDN):** Functions as the global Content Delivery Network (CDN) to cache, secure, and deliver the static files with low latency.
3.  **Lambda:** Contains small python API used to fetch visitors data from DynamoDB table which is updated with each visitor. Configured with function URL and CORS to allow API calls from website's origin only.
4.  **DynamoDB:** Table holds information about website's visitors.
5.  **Route 53:** Manages the DNS records, pointing the custom domain to the CloudFront distribution.
6.  **ACM** An SSL/TLS certificate is managed by AWS Certificate Manager and associated with the CloudFront distribution to ensure secure, encrypted traffic.
7.  **IAM:** Used to define users, roles and policies for GitHub Actions and Terraform to securely interact with and manage AWS resources.

---

### Infrastructure & Deployment

| Category | Technology | Purpose |
| :--- | :--- | :--- |
| **Infrastructure as Code (IaC)** | **Terraform** | Used to define, provision, and manage the entire AWS infrastructure stack. Remote backend operates in seperate S3 bucket with versioning and tfstate file locking enbled. |
| **CI/CD** | **GitHub Actions** | Automates the build and deployment pipeline, handling both infrastructure changes (via Terraform) and website content updates. |
| **Version Control** | **Git/GitHub** | Source control for both the website code and the infrastructure code. |

### Website Content

| Category | Technology | Purpose |
| :--- | :--- | :--- |
| **Markup** | **HTML5** | Structure and content of the website. |
| **Styling** | **CSS3** | Presentation and visual design. |
| **Interactivity** | **JavaScript** | Handling API calls to fetch number of visitors and updates website's coutner. |

---

## ⚙️ Deployment and CI/CD

The deployment workflow is fully automated via **GitHub Actions**.

1.  **Code Commit:** Any push to the main branch triggers the CI/CD pipeline.
2.  **Infrastructure Changes (Terraform):** The pipeline job formats and validates the resource configuration. Then generates plan of the infrastructure and applies it to provision or update the AWS resources based on the configuration files.
3.  **Website S3 Sync:** Once infrastructure is provisioned website files are uploaded to S3 bucket via sync job.
4.  **CloudFront Invalidation:** Last job is triggered after content updates to ensure the latest version of the website is immediately available to all users globally.

---
