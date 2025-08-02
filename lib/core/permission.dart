class Permission {
  final List<String> _permissions;
  final List<String> _roles;

  const Permission(this._permissions, this._roles);

  bool can(String permission) {
    return _permissions.contains(permission);
  }

  bool hasRole(String role) {
    return _roles.contains(role);
  }

  // User permissions
  bool canCreateUser() => can('create:user');
  bool canReadUser() => can('read:user');
  bool canReadSelfUser() => can('read:user:self');
  bool canUpdateUser() => can('update:user');
  bool canUpdateSelfUser() => can('update:user:self');
  bool canDeleteUser() => can('delete:user');
  bool canDeleteSelfUser() => can('delete:user:self');

  // Client permissions
  bool canCreateClient() => can('create:client');
  bool canReadClient() => can('read:client');
  bool canReadSelfClient() => can('read:client:self');
  bool canUpdateClient() => can('update:client');
  bool canUpdateSelfClient() => can('update:client:self');
  bool canDeleteClient() => can('delete:client');
  bool canDeleteSelfClient() => can('delete:client:self');

  // Employee permissions
  bool canCreateEmployee() => can('create:employee');
  bool canReadEmployee() => can('read:employee');
  bool canReadSelfEmployee() => can('read:employee:self');
  bool canUpdateEmployee() => can('update:employee');
  bool canUpdateSelfEmployee() => can('update:employee:self');
  bool canDeleteEmployee() => can('delete:employee');
  bool canDeleteSelfEmployee() => can('delete:employee:self');

  // Persona permissions
  bool canCreatePersona() => can('create:persona');
  bool canReadPersona() => can('read:persona');
  bool canUpdatePersona() => can('update:persona');
  bool canDeletePersona() => can('delete:persona');
  bool canCreatePersonaReview() => can('create:persona_review');

  // Scenario permissions
  bool canCreateScenario() => can('create:scenario');
  bool canReadScenario() => can('read:scenario');
  bool canUpdateScenario() => can('update:scenario');
  bool canDeleteScenario() => can('delete:scenario');
  bool canCreateScenarioReview() => can('create:scenario_review');

  // Invoice permissions
  bool canCreateInvoice() => can('create:invoice');
  bool canReadInvoice() => can('read:invoice');
  bool canUpdateInvoice() => can('update:invoice');
  bool canDeleteInvoice() => can('delete:invoice');

  // Roles
  bool isAdmin() => hasRole('admin');
  bool isRcc() => hasRole('rcc');
}
