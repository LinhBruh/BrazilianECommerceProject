Networking decision:
The baseline architecture does not create a customer-managed VPC because
all current components are serverless regional AWS services.

A VPC will be introduced only when the pipeline requires access to private
resources such as RDS, EC2, or private JDBC data sources.