# Keycloak realm with LDAP federation and automatic realm-admin role

Inspired by https://www.janua.fr/mapping-ldap-group-and-roles-to-redhat-sso-keycloak/

Docker container with preloaded LDAP users and groups by https://github.com/rroemhild/docker-test-openldap

## Setup

Start the necessary docker containers.

```
cd docker
docker compose up -d
cd ..
```

Wait a bit until the keycloak container is up and running.
It's ready when `docker logs -f kc_admin_keycloak` shows "Running the server in development mode. DO NOT use this configuration in production."

Create the realm "futurama" with user federation to the `kc_admin_ldap` container

```
cd terraform
terraform init
terraform apply
cd ..
```

## Testing the setup

### Normal user login

1. Open http://localhost:8099/realms/futurama/account/
2. Login as "professor@planetexpress.com/professor" or "bender@planetexpress.com/bender" for example --> both work

### Login as admin of realm "futurama" 

1. Open http://localhost:8099/admin/futurama/console/
2. Login as "bender@planetexpress.com/bender" --> you should see a mostly blank page with message "Request failed with status code 403" 
3. Logout
4. Login as "professor@planetexpress.com/professor" --> you should see a "Welcome to futurama" page plus full menu to manage the realm 

## Additional information

- If you want to know which other users exist and how to access the LDAP directory with LDAP tools, check https://github.com/rroemhild/docker-test-openldap
- It's also possible to log in a full keycloak admin at http://localhost:8099/admin/master/console/ with "admin/admin"
