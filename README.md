# Managing infrastructure as code with Terraform, Cloud Build, and GitOps

This is the repo for the [Managing infrastructure as code with Terraform, Cloud Build, and GitOps](https://cloud.google.com/solutions/managing-infrastructure-as-code) tutorial. This tutorial explains how to manage infrastructure as code with Terraform and Cloud Build using the popular GitOps methodology. 

# Configuring the project
Create the state buckets
```bash
PROJECT_ID=$(gcloud config get-value project)
gsutil mb gs://$PROJECT_ID-tfstate
gsutil versioning set on gs://$PROJECT_ID-tfstate/
```
Update the projectID value on the terraform.tfvars and backend.tf files
```bash
cd ~/solutions-terraform-cloudbuild-gitops
sed -i s/PROJECT_ID/$PROJECT_ID/g environments/*/terraform.tfvars
sed -i s/PROJECT_ID/$PROJECT_ID/g environments/*/backend.tf
```
If everything is ok then push the changes to your repo
```bash
git add --all
git commit -m "Update project IDs and buckets"
git push origin dev
```
# Configuring cloud Build
Retrieves cloud build service account and grant it roles/editor rights
```bash
gcloud services enable cloudbuild.googleapis.com
CLOUDBUILD_SA="$(gcloud projects describe $PROJECT_ID \
    --format 'value(projectNumber)')@cloudbuild.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$CLOUDBUILD_SA --role roles/editor
```

# required API's
```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable servicenetworking.googleapis.com
```
# required service account
```bash
gcloud iam service-accounts create dasilva-gke
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:dasilva-gke@$PROJECT_ID.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:dasilva-gke@$PROJECT_ID.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:dasilva-gke@$PROJECT_ID.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:dasilva-gke@$PROJECT_ID.iam.gserviceaccount.com --role roles/container.admin
```



## Configuring your **dev** environment

Just for demostration, this step will:
 1. Configure an apache2 http server on network '**dev**' and subnet '**dev**-subnet-01'
 2. Open port 80 on firewall for this http server 

```bash
cd ../environments/dev
terraform init
terraform plan
terraform apply
terraform destroy
```

## Promoting your environment to **production**

Once you have tested your app (in this example an apache2 http server), you can promote your configuration to prodution. This step will:
 1. Configure an apache2 http server on network '**prod**' and subnet '**prod**-subnet-01'
 2. Open port 80 on firewall for this http server 

```bash
cd ../prod
terraform init
terraform plan
terraform apply
terraform destroy
```
