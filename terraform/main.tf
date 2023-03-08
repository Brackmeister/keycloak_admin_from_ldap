resource "keycloak_realm" "realm" {
  realm   = "futurama"
  enabled = true
}

resource "keycloak_ldap_user_federation" "ldap_user_federation" {
  name     = "openldap"
  realm_id = keycloak_realm.realm.id
  enabled  = true

  username_ldap_attribute = "mail"
  rdn_ldap_attribute      = "cn"
  uuid_ldap_attribute     = "entryDN"
  user_object_classes     = [
    "inetOrgPerson"
  ]
  connection_url  = "ldap://ldap:10389"
  users_dn        = "ou=people,dc=planetexpress,dc=com"
  bind_dn         = "cn=admin,dc=planetexpress,dc=com"
  bind_credential = "GoodNewsEveryone"

  connection_timeout = "5s"
  read_timeout       = "10s"

  trust_email = true
}

resource "keycloak_ldap_user_attribute_mapper" "username_mapper" {
  realm_id                = keycloak_realm.realm.id
  ldap_user_federation_id = keycloak_ldap_user_federation.ldap_user_federation.id
  name                    = "username"

  ldap_attribute       = "mail"
  user_model_attribute = "username"
  is_mandatory_in_ldap = true
  read_only            = true
}

resource "keycloak_ldap_role_mapper" "ldap_role_mapper" {
  realm_id                = keycloak_realm.realm.id
  ldap_user_federation_id = keycloak_ldap_user_federation.ldap_user_federation.id
  name                    = "role-mapper"

  ldap_roles_dn            = "ou=people,dc=planetexpress,dc=com"
  role_name_ldap_attribute = "cn"
  role_object_classes      = [
    "Group"
  ]
  mode                           = "IMPORT"
  membership_attribute_type      = "DN"
  membership_ldap_attribute      = "member"
  membership_user_ldap_attribute = "cn"
  user_roles_retrieve_strategy   = "LOAD_ROLES_BY_MEMBER_ATTRIBUTE"
}
