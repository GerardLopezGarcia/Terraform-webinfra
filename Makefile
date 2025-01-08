plan-dev:
	aws s3 cp s3://s3nhterraformstate/RUN/DEVRUNWORKSPACE/output_vars.txt terraform.tfvars
	terraform init
	terraform plan -var-file="environments/dev.tfvars" -out plan

apply-dev-plan:
	 terraform apply "plan" && rm plan
