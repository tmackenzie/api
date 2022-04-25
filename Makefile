SHELL := /bin/bash

build:
	docker build -t api .

run:
	docker run --publish 80:80 api

publish: build
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 221039308519.dkr.ecr.us-east-1.amazonaws.com
	docker tag api:latest 221039308519.dkr.ecr.us-east-1.amazonaws.com/api:latest
	docker tag api:latest 221039308519.dkr.ecr.us-east-1.amazonaws.com/api:latest
	docker push 221039308519.dkr.ecr.us-east-1.amazonaws.com/api:latest

plan-shared:
	cd terraform/shared; tfswitch
	terraform init -input=false
	terraform plan -input=false -no-color -compact-warnings -out plan.tfplan

apply-shared:
	cd terraform/shared; tfswitch
	terraform init -input=false
	terraform apply -input=false -no-color -compact-warnings -auto-approve

plan:
	cd terraform/stacks; tfswitch
	cd terraform/stacks; terraform init -input=false
	cd terraform/stacks; terraform plan -input=false -no-color -compact-warnings -out plan.tfplan

apply:
	cd terraform/stacks; tfswitch
	cd terraform/stacks; terraform init -input=false
	cd terraform/stacks; terraform apply -input=false -no-color -compact-warnings -auto-approve

destroy:
	cd terraform/stacks; tfswitch
	cd terraform/stacks; terraform init -input=false
	cd terraform/stacks; terraform destroy -input=false -no-color -compact-warnings
