# Prototype — refonte visuelle de l'espace de gestion (JETABLE)

Question : à quoi doit ressembler la refonte visuelle de l'espace de gestion (admin et guide) ?
Verdict : variante **D « Clair & vert »** retenue — la clarté et la densité de B, l'identité de C
(sidebar et bottom nav vert foncé, en-têtes verts, photo courte en tête de la feuille de balade),
le bloc date façon calendrier dans la liste des balades, de grandes cases pour pointer les présents.
A (Carnet de terrain) rejetée.

Lancer : `flutter run -d chrome --dart-define=PROTOTYPE=true`, puis
`/admin/balade/<id>?variant=D`, `/admin?variant=D`, `/admin/reservations?variant=D`.

Ce code ne va pas dans `main` : il est réécrit proprement lors de l'implémentation.
