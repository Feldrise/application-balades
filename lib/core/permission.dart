class Permission {
  final List<String> _permissions;
  final List<String> _roles;

  const Permission(this._permissions, this._roles);

  bool can(String permission) => _permissions.contains(permission);

  bool hasRole(String role) => _roles.contains(role);

  // Roles
  bool isAdmin() => hasRole('admin');

  bool isGuide() => hasRole('guide');

  bool canAccessAdminArea() => isAdmin() || isGuide();

  // User management (admin)
  bool canCreateUser() => can('create:user');

  // Balades
  bool canReadRamble() => can('read:ramble');

  bool canCreateRamble() => can('create:ramble');

  bool canUpdateRamble() => can('update:ramble');

  bool canUpdateOwnRamble() => can('update:ramble:self');

  bool canDeleteRamble() => can('delete:ramble');

  bool canDeleteOwnRamble() => can('delete:ramble:self');

  // Registrations (own balades)
  bool canViewAllRegistrations() => can('view:all-registrations');

  bool canViewOwnRegistrations() => can('view:registrations:self');

  bool canUpdateRegistrationDetails() => can('update:registration-details') || can('update:registration-details:self');

  bool canUpdateRegistrationStatus() => can('update:registration-status') || can('update:registration-status:self');

  bool canManageRegistration() => can('manage:registration') || can('manage:registration:self');

  bool canBulkRegistrationActions() => can('bulk:registration-actions') || can('bulk:registration-actions:self');

  // Profile / payments
  bool canReadSelfUser() => can('read:user:self');

  bool canUpdateSelfUser() => can('update:user:self');

  bool canConfigureGuidePayments() => can('configure:guide-payments:self');
}
