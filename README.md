# Resume Website on AWS

### Website can be accessed at: karolurban.com

## 🚀 Project Overview

This repository contains the Infrastructure as Code (IaC) and configuration files for deploying a personal static resume website. The project is hosted entirely on **Amazon Web Services (AWS)** using a serverless architecture for low maintenance, and cost efficiency.

The infrastructure is provisioned and managed using **Terraform**, and the entire deployment process is automated via a continuous integration and continuous deployment (CI/CD) pipeline built with **GitHub Actions**.

The website utilizes a modern static-site hosting pattern combined with a Content Delivery Network (CDN) to ensure fast load times and global reach.

---

### Architecture Diagram





### Architecture Components:

1.  **User Access:** Website visitors access the site via a custom domain (e.g., `yourname.com`).
2.  **Content Delivery Network (CDN):** **Amazon CloudFront** caches the website content at edge locations worldwide, providing low-latency delivery and automatically handling HTTPS.
3.  **Static Storage:** The raw website files (HTML, CSS, JS) are stored in a private **Amazon S3 Bucket**. CloudFront is configured to serve content exclusively from this S3 bucket, preventing direct public access.
4.  **DNS/Routing:** **Amazon Route 53** manages the DNS records, pointing the custom domain to the CloudFront distribution.
5.  **Security:** An SSL/TLS certificate is managed by **AWS Certificate Manager (ACM)** and associated with the CloudFront distribution to ensure secure, encrypted traffic.

---

## 🛠️ Technologies Used

This project leverages a powerful stack of tools for infrastructure management, deployment, and front-end presentation.

### Infrastructure & Deployment

| Category | Technology | Purpose |
| :--- | :--- | :--- |
| **Infrastructure as Code (IaC)** | **Terraform** | Used to define, provision, and manage the entire AWS infrastructure stack (S3, CloudFront, Route 53, ACM). |
| **CI/CD** | **GitHub Actions** | Automates the build and deployment pipeline, handling both infrastructure changes (via Terraform) and website content updates. |
| **Version Control** | **Git/GitHub** | Source control for both the website code and the infrastructure code. |

### Website Content

| Category | Technology | Purpose |
| :--- | :--- | :--- |
| **Markup** | **HTML5** | Structure and content of the resume. |
| **Styling** | **CSS3** | Presentation and visual design of the website. |
| **Interactivity** | **JavaScript** | Handling client-side functionality and dynamic elements. |

---

## ☁️ AWS Services

The core of the hosting solution is built upon the following Amazon Web Services:

* **Amazon S3 (Simple Storage Service):** Acts as the origin server for the static website content. A separate bucket is often used for Terraform state files (backend).
* **Amazon CloudFront:** Functions as the global Content Delivery Network (CDN) to cache, secure, and deliver the static files with low latency.
* **Amazon Route 53:** Manages the custom domain name and creates the necessary DNS records (e.g., CNAME or Alias records) to route traffic to the CloudFront distribution.
* **AWS Certificate Manager (ACM):** Provides the free, managed SSL/TLS certificate required to enable HTTPS on the CloudFront distribution.
* **AWS Identity and Access Management (IAM):** Used to define roles and policies for GitHub Actions to securely interact with and manage AWS resources.

---

## ⚙️ Deployment and CI/CD

The deployment workflow is fully automated via **GitHub Actions**.

1.  **Code Commit:** Any push to the main branch triggers the CI/CD pipeline.
2.  **Website Build:** Static files are compiled (if necessary) and synchronized to the S3 content bucket.
3.  **Infrastructure Changes (Terraform):** The pipeline runs `terraform plan` and `terraform apply` to provision or update the AWS resources based on the configuration files.
4.  **Invalidation:** A **CloudFront Invalidation** is triggered after content updates to ensure the latest version of the website is immediately available to all users globally.

---

## 📝 Getting Started

### Prerequisites

To manage and deploy this project, you will need:

* An **AWS Account** with configured credentials.
* A custom **Domain Name** managed by Route 53 (or elsewhere, with corresponding setup).
* **Terraform CLI** installed locally (for testing/local development).
* **GitHub Repository Secrets** configured for your AWS access keys used by GitHub Actions.

### Local Setup

1.  Clone the repository:
    ```bash
    git clone [https://github.com/urbanconfig/aws-resume-website.git](https://github.com/urbanconfig/aws-resume-website.git)
    cd aws-resume-website
    ```
2.  Review the `main.tf` and variable files to understand the infrastructure definition.
3.  Initialize Terraform:
    ```bash
    terraform init
    ```
4.  Review the plan (optional):
    ```bash
    terraform plan
    ```
5.  Apply the configuration to deploy the infrastructure:
    ```bash
    terraform apply
    ```