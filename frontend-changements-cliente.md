# Changements frontend — demandes cliente

Ce document décrit les modifications à apporter à l'application Flutter (`balade/`) suite aux changements backend déjà implémentés.

## Prérequis infra (hors Flutter)

Avant que les uploads photos fonctionnent en production, ajouter sur le VPS nginx :

```nginx
server {
    client_max_body_size 10M;
    # ... reste de la config
}
```

Puis : `sudo nginx -t && sudo systemctl reload nginx`

Sans cela, toute image encodée en base64 au-delà d'environ 750 Ko sera rejetée (erreur 413) avant d'atteindre l'API.

---

## 1. Téléphone personnel du guide

### Contexte backend

Le champ `phone` existe déjà dans l'API (`GET /guides`, `GET /guides/me`, `guides[]` dans les balades). Aucun changement backend requis.

### État actuel Flutter

- Le champ est **commenté** dans `lib/features/guides/widgets/guide_form.dart` (lignes 139-143)
- L'initialisation du contrôleur est commentée (ligne 59)
- Le téléphone n'est **pas affiché** dans `lib/features/ramble/public_ramble_details_page/widgets/guide_big_card.dart`

### Modifications à faire

#### 1.1 Formulaire guide (`guide_form.dart`)

1. Décommenter le `PhoneFormField` dans la section « Informations personnelles »
2. Initialiser le contrôleur dans `initState()` :

```dart
if (widget.initialGuide?.phone != null && widget.initialGuide!.phone!.isNotEmpty) {
  _phoneController.value = PhoneNumber.parse(widget.initialGuide!.phone!);
}
```

3. Le champ est déjà envoyé dans `save()` via `'phone': _phoneController.value.toString()` — rien à changer côté payload

#### 1.2 Affichage public (`guide_big_card.dart`)

Ajouter sous le nom/certification, si `guide.phone` est renseigné :

```dart
if (guide.phone != null && guide.phone!.isNotEmpty) ...[
  const SizedBox(height: 8),
  InkWell(
    onTap: () => launchUrl(Uri.parse('tel:${guide.phone}')),
    child: Row(
      children: [
        Icon(Icons.phone, size: 18, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(guide.phone!, style: theme.textTheme.bodyMedium),
      ],
    ),
  ),
],
```

Importer `package:url_launcher/url_launcher.dart` (déjà dans `pubspec.yaml`).

#### 1.3 Profil guide (`guide_profile_page.dart`)

Optionnel : afficher le téléphone en lecture seule dans l'en-tête si renseigné, en complément du formulaire éditable.

---

## 2. Point GPS du lieu de rendez-vous

### Nouveaux champs API

| Champ JSON | Type | Description |
|------------|------|-------------|
| `meeting_latitude` | `float64` nullable | Latitude du point de RDV |
| `meeting_longitude` | `float64` nullable | Longitude du point de RDV |

Disponibles dans `GET /rambles`, `GET /rambles/{id}`, `POST /rambles`, `PUT /rambles/{id}`.

### Modifications à faire

#### 2.1 Modèle `Ramble` (`lib/features/ramble/models/ramble/ramble.dart`)

Ajouter les champs freezed :

```dart
@JsonKey(name: 'meeting_latitude') double? meetingLatitude,
@JsonKey(name: 'meeting_longitude') double? meetingLongitude,
```

Puis exécuter : `dart run build_runner build --delete-conflicting-outputs`

#### 2.2 Formulaire balade (`lib/features/ramble/widget/ramble_form/ramble_form.dart`)

Dans la section « Informations pratiques », sous le champ « Point de rendez-vous » :

- Deux `TextFormField` numériques : « Latitude » et « Longitude »
- Placeholder : `48.8566` / `2.3522`
- Validation optionnelle : si l'un est renseigné, l'autre doit l'être aussi
- Envoyer dans le payload :

```dart
'meeting_latitude': double.tryParse(_meetingLatitudeController.text),
'meeting_longitude': double.tryParse(_meetingLongitudeController.text),
```

**Amélioration future (hors scope minimal)** : bouton « Utiliser ma position » via `geolocator` ou sélection sur carte.

#### 2.3 Affichage public (`ramble_details_info.dart`)

Sous la ligne « Point de rendez-vous », si lat/lng présents :

```dart
if (ramble.meetingLatitude != null && ramble.meetingLongitude != null)
  _buildMapsLink(context, ramble.meetingLatitude!, ramble.meetingLongitude!),
```

Helper :

```dart
Future<void> _openMaps(double lat, double lng) async {
  final uri = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
```

Afficher un bouton ou lien « Voir sur Google Maps » avec icône `Icons.map`.

---

## 3. Photos plus lourdes

### Contexte backend

- Limite API : **10 Mo** (middleware `MaxBodySize`)
- Les erreurs d'upload remontent maintenant en **400** avec message explicite (`failed to save cover image: ...`)
- Format inchangé : `cover_image_base64` / `avatar_base64` en JSON

### État actuel Flutter

- Limite client : **5 Mo** dans `lib/core/forms/image_input.dart` et `image_input_round.dart`
- Cette limite est **correcte** et compatible avec nginx 10 Mo (+ overhead base64 ~33 %)

### Modifications à faire

#### 3.1 Aucun changement obligatoire sur la limite 5 Mo

La limite actuelle est adaptée. Si la cliente souhaite monter à 8 Mo par exemple, modifier la constante dans les deux fichiers `image_input*.dart` et le message dans `size_limit_dialog.dart`.

#### 3.2 Gestion d'erreur API (`ramble_form.dart`, `guide_form.dart`)

Les erreurs d'upload sont maintenant retournées par l'API. S'assurer que `ErrorSnackbar` / `api_error_message.dart` affiche le message d'erreur du body JSON (ex. « failed to save cover image ») plutôt qu'un message générique.

#### 3.3 Checklist déploiement

- [ ] Configurer `client_max_body_size 10M` sur nginx (voir prérequis infra)
- [ ] Redéployer l'API
- [ ] Tester upload d'une image ~2-3 Mo sur une balade et un avatar guide

---

## 4. Dupliquer une balade

### Nouvel endpoint API

```
POST /api/v1/rambles/{id}/duplicate
Authorization: Bearer <token>
Permission: update:ramble ou update:ramble:self (propriétaire)
```

**Body optionnel :**

```json
{
  "date": "2026-09-15T10:00:00Z",
  "title": "Balade en forêt (septembre)"
}
```

**Comportement :**
- Copie description, type, lieu, GPS, tarifs, guides, image, document, config paiement
- **Ne copie pas** : inscriptions, annulation
- La copie démarre en **brouillon** (`published_at = null`)
- Titre par défaut : `"{titre original} (copie)"`

**Réponse :** `201` avec l'objet `Ramble` créé

### Modifications à faire

#### 4.1 Service (`lib/features/ramble/rambles_service.dart`)

```dart
Future<Ramble> duplicateRamble(
  int id, {
  DateTime? date,
  String? title,
  required String authorization,
}) async {
  final body = <String, dynamic>{};
  if (date != null) body['date'] = date.toUtc().toIso8601String();
  if (title != null) body['title'] = title;

  final response = await http.post(
    Uri.parse('$serviceBaseUrl/$id/duplicate'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authorization',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to duplicate ramble: ${response.body}');
  }

  return Ramble.fromJson(jsonDecode(response.body) as Map<String, Object?>);
}
```

#### 4.2 UI admin

Ajouter un bouton « Dupliquer » dans la liste des balades (`rambles_list.dart` ou `rambles_content.dart`) et/ou la page détail admin.

**Flux recommandé :**
1. Clic sur « Dupliquer »
2. Dialogue avec sélecteur de date (obligatoire ou optionnel) et titre pré-rempli `"{titre} (copie)"`
3. Appel API
4. Snackbar de succès + rechargement de la liste
5. Optionnel : ouvrir directement le formulaire d'édition de la copie (brouillon) pour ajuster avant publication

Icône suggérée : `Icons.copy`

---

## 5. Publication planifiée / brouillon

### Nouveau champ API

| Champ JSON | Type | Comportement |
|------------|------|-------------|
| `published_at` | `datetime` nullable | `null` = brouillon, date future = planifiée, date passée = publiée |

### Règles de visibilité

| `published_at` | Visible publiquement | Inscriptions |
|----------------|---------------------|--------------|
| `null` | Non | Refusées |
| Date future | Non | Refusées |
| Date passée/présente | Oui | Autorisées |

Les balades existantes ont été migrées automatiquement (`published_at` = date de la balade ou date de création).

### Query param admin

```
GET /rambles?include_unpublished=true
GET /rambles/{id}?include_unpublished=true
```

Nécessite un token avec permission `create:ramble` ou `update:ramble`. Sans ce paramètre, seules les balades publiées sont retournées.

### Création de balade

| Payload | Résultat |
|---------|----------|
| (rien) | Publiée immédiatement (`published_at = now`) |
| `"is_draft": true` | Brouillon |
| `"published_at": "2026-08-01T08:00:00Z"` | Planifiée ou publiée selon la date |

### Modifications à faire

#### 5.1 Modèle `Ramble`

```dart
@JsonKey(name: 'published_at') @DateSerializer() DateTime? publishedAt,
```

Ajouter un getter utilitaire :

```dart
bool get isPublished =>
  publishedAt != null && !publishedAt!.isAfter(DateTime.now());

bool get isDraft => publishedAt == null;

bool get isScheduled =>
  publishedAt != null && publishedAt!.isAfter(DateTime.now());
```

#### 5.2 Service (`rambles_service.dart`)

Ajouter le paramètre `includeUnpublished` à `fetchRambles` et `fetchRamble` :

```dart
if (includeUnpublished) {
  queryParameters['include_unpublished'] = 'true';
}
```

**Important :** passer `includeUnpublished: true` dans toutes les vues **admin** (liste, détail, édition). Laisser `false` (défaut) pour les vues publiques.

#### 5.3 Formulaire balade (`ramble_form.dart`)

Nouvelle section « Publication » :

| Choix UI | Payload envoyé |
|----------|----------------|
| Publier maintenant | `"published_at": DateTime.now().toUtc().toIso8601String()` |
| Brouillon | `"is_draft": true` (création) ou `"published_at": null` (mise à jour) |
| Planifier | `"published_at": "<date choisie>"` |

Utiliser un `SegmentedButton` ou `RadioListTile` + `DateTimePicker` pour la date de parution.

À l'édition, pré-sélectionner l'état actuel selon `isDraft` / `isScheduled` / `isPublished`.

#### 5.4 Liste admin (`rambles_list.dart`, `rambles_content.dart`)

Badge sur chaque carte/ligne :

| État | Couleur | Label |
|------|---------|-------|
| Brouillon | gris | « Brouillon » |
| Planifiée | orange | « Planifié le dd/MM/yyyy » |
| Publiée | vert (ou rien) | — |

#### 5.5 Vue publique

Aucun changement nécessaire si l'API filtre correctement : les brouillons/planifiées n'apparaîtront plus dans la liste publique.

Vérifier que les liens directs vers une balade non publiée affichent une erreur 404 (comportement API actuel).

#### 5.6 Inscriptions

Si l'utilisateur tente de s'inscrire à une balade non publiée (cas edge, lien en cache), l'API retourne :

```json
{ "error": "cannot register for an unpublished ramble" }
```

Afficher ce message clairement dans `ramble_registration_section.dart`.

---

## 6. Signature email

**Aucun changement frontend.** Traitée côté templates HTML backend.

---

## Ordre d'implémentation recommandé

1. **Téléphone guide** — rapide, frontend seul
2. **GPS lieu de RDV** — modèle + formulaire + affichage
3. **Publication** — modèle + service + formulaire + badges admin (impact visible sur la liste)
4. **Duplication** — service + bouton admin
5. **Photos** — vérifier nginx en prod + messages d'erreur API

---

## Fichiers Flutter principaux à modifier

| Fichier | Changements |
|---------|-------------|
| `lib/features/guides/widgets/guide_form.dart` | Téléphone |
| `lib/features/ramble/public_ramble_details_page/widgets/guide_big_card.dart` | Affichage téléphone |
| `lib/features/ramble/models/ramble/ramble.dart` | `meetingLatitude`, `meetingLongitude`, `publishedAt` |
| `lib/features/ramble/widget/ramble_form/ramble_form.dart` | GPS + publication |
| `lib/features/ramble/public_ramble_details_page/widgets/ramble_details_info.dart` | Lien Google Maps |
| `lib/features/ramble/rambles_service.dart` | `duplicateRamble`, `include_unpublished` |
| `lib/features/admin/admin_home_page/widgets/rambles_list.dart` | Bouton dupliquer, badges publication |
| `lib/core/forms/image_input.dart` | (optionnel) ajuster limite / message |

---

## Tests manuels suggérés

- [ ] Saisir et sauvegarder un téléphone guide, vérifier affichage sur la fiche balade publique
- [ ] Créer une balade avec lat/lng, vérifier le lien Google Maps
- [ ] Uploader une photo ~2 Mo (après config nginx)
- [ ] Dupliquer une balade, vérifier brouillon + contenu copié
- [ ] Créer un brouillon : invisible en public, visible en admin avec `include_unpublished=true`
- [ ] Planifier une balade dans 1h : invisible maintenant, visible après l'heure
- [ ] Tenter une inscription sur brouillon : message d'erreur explicite
