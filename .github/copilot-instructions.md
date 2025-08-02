# GitHub Copilot Instructions for Balade Écologique (Flutter + Go SaaS)

## Project Overview

**Balade Écologique** est une application web et mobile développée en Flutter, appuyée par une API Go (REST), qui permet de gérer des balades naturalistes dynamiques, organisées en fonction des conditions environnementales (champignons, oiseaux, plantes, etc.).

Cette solution SaaS a pour but de :

- Permettre aux organisateurs de créer des balades à créneaux flexibles.
- Gérer les inscriptions avec capacité limitée et file d’attente intelligente.
- Relancer automatiquement les participants pour confirmation.
- Notifier les personnes en attente dès qu’une place se libère ou qu’un nouveau créneau est disponible.
- Fournir une interface fluide, mobile-first et administrable par des non-techniciens.

## Architecture Guidelines

L'application suit une architecture modulaire en Clean Architecture, avec séparation logique des couches (UI / Logic / Infrastructure / API).

### Project Structure

```

balade\_app/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── services/           # API client, notifications, mail
│   │   ├── widgets/            # Commun reusable widgets
│   │   ├── utils.dart
│   ├── features/
│   │   ├── balades/            # Gestion des créneaux
│   │   ├── inscriptions/       # Formulaires et logique d’inscription
│   │   ├── admin/              # Dashboard admin (gestion créneaux & listes)
│   │   ├── user\_account/       # Mon compte / mes balades
│   │   └── navigation/
│   └── theme/                  # Design system
├── assets/
├── test/
├── pubspec.yaml
└── README.md

```

---

## Core Components

### State Management

- **Riverpod** utilisé globalement.
- Providers par domaine fonctionnel (balades, inscriptions, file d’attente, notifications).
- `StateNotifier` ou `AsyncNotifier` pour les flux utilisateur/admin.

### Balade Management (Créneaux)

- Page admin pour :
  - Créer/modifier un créneau
  - Définir le nombre de places
  - Activer/désactiver la publication
  - Marquer un créneau comme _confirmé_ ou _annulé_
- Chaque créneau contient :
  - Type de balade
  - Date/heure
  - Localisation
  - Capacité
  - Description publique
  - Statut

### Inscriptions & File d’attente

- Formulaire d’inscription avec validation (nom, email, téléphone)
- Gestion de :
  - file d’attente automatique
  - annulations utilisateurs
  - recontact automatique X jours avant
- Envoi automatique d’un lien de confirmation
- Les utilisateurs doivent confirmer leur présence → sinon, la place est réattribuée

### Notifications

- Envoi de mails via un service backend (Sendgrid, Mailgun ou SMTP)
- Notifications automatiques (confirmations, rappels, désistements)
- Push possible si web + mobile (Firebase Cloud Messaging)

### API Communication

- Tous les appels passent par une API Go (REST).
- Principaux endpoints :
  - `POST /regsiter` – Nouvelle inscription à une balade
  - `POST /confirmation?token=token` – Confirme la venue d’un inscrit
  - `GET /balades` – Liste publique des créneaux
  - `POST /balades` – (Admin) Créer un créneau
  - `POST /cancel` – (User) Annuler sa participation

### Admin Dashboard

- Accessible aux organisateurs via un login simple
- Vue liste / calendrier des balades
- Vue des inscrits avec filtres (confirmés, file d’attente, absents)
- Export CSV / PDF de la liste des participants

### Theming & Design

- Mobile-first avec responsive web
- Design nature et apaisant
- Polices recommandées :
  - **Lato** pour titres
  - **Lora** pour le corps

### Navigation

- **GoRouter** utilisé
- Routes principales :
  - `/` → Liste des balades disponibles
  - `/balade/:id` → Détail d’une balade
  - `/admin` → Dashboard organisateur
  - `/mon-compte` → Historique des inscriptions
  - `/confirmation?token=token` → Confirmation de participation

---

## Workflows

### Inscription à une balade

1. L’utilisateur remplit le formulaire.
2. Si des places sont disponibles, il est inscrit.
3. Sinon, il entre en file d’attente.
4. Il reçoit un mail de confirmation ou d’attente.

### Confirmation (J-3 par exemple)

1. L’administrateur confirme la tenue du créneau.
2. Les inscrits reçoivent une demande de confirmation.
3. Ceux qui ne répondent pas 24h avant la balade voient leur place réattribuée.
4. Les personnes en file d’attente sont contactées par ordre d’inscription.

---

## Best Practices

- Utiliser `freezed` pour les modèles.
- Centraliser les appels réseau et gestion d’erreurs.
- Utiliser `const` pour les composants statiques.
- Découpler logique UI et logique métier.
- Modulariser par domaine métier.

---

## Commands

```bash
# Install dependencies
flutter pub get

# Generate models
dart pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run -d chrome

# Run tests
flutter test

# Build web version
flutter build web --release
```

---

## Release Checklist

- [ ] Créneaux s’affichent correctement
- [ ] Formulaire d’inscription validé
- [ ] File d’attente fonctionnelle
- [ ] Mails de confirmation envoyés
- [ ] Processus de relance validé (J-3)
- [ ] Interface admin fonctionnelle
- [ ] Responsive vérifié (mobile & desktop)
- [ ] API fonctionnelle
- [ ] Tests OK
- [ ] Documentation & README à jour
