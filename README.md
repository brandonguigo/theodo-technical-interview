# Theodo Interview

Instructions was:
```
-   Écrire un module Terraform qui provisionne une base de données (MySQL ou PostgreSQL, au choix) sur GCP.
-   Donner au moins un exemple d'utilisation du module.
-   Documenter le raisonnement derrière la conception du module (choix de variables, etc.)
-   Mettre l'accent sur la qualité et les bonnes pratiques.
-   Documenter et justifier les pratiques choisies.
```

# TF module

Located inside `modules/cloud-sql`.
a README.md is also available under `modules/cloud-sql` which goes a bit deeper inside the module

# Examples:

- `basic-instance.tf`: spawn a small instance inside a private network
- `ha-instance.tf`: spawn a regional region, with backups, on a private network

# Choices:

I decided to use the existing cloud SQL module that google offers.
This allows to have tested and working terraform code quickly (no need to reinvent the wheel, if not needed).
The module created for the tests serves as a wrapper of the Google Module, simpler.
It can be pushed further and be personalized to offer standardized DB deployment across a set of infrastructures / projects / databases.

# vars

Module offers a small set of parameters that the user can customize:
- basic instance config: type, region, project, tier, engine version etc...
- basic storage config: disk type and size
- backups: default or advanced customization
- auto creation of users and root password: username provided and password are randomly generated
- private IP access: give a private network name and an ip and you're good to go.

# enhancements possible
- support IAM identification for database users (via IAM SAC or users)
- support workload identity with SAC (to use in k8s if necessary)
- reduce the number of default parameters ==> make more settings automatic by default inside the module
...