# FoodReminder

Petit plugin LOTRO permettant de regrouper des consommables et autres raccourcis dans une fenêtre configurable.

## Installation

Copie le dossier `Dusk` dans :

`Documents/The Lord of the Rings Online/Plugins/`

Puis en jeu :

`/plugins refresh`

`/plugins load FoodReminder`

## Utilisation

- Glisse un raccourci dans une case.
- Clic droit ou molette sur une case : supprime le raccourci lorsque les cases sont déverrouillées.
- Clic gauche sur l'icône : affiche/masque FoodReminder.
- Clic droit sur l'icône : ouvre les options.
- Maj + clic gauche sur l'icône : verrouille/déverrouille les raccourcis.
- `/Fo help` : affiche toutes les commandes.

## Compatibilité des sauvegardes

FoodReminder conserve volontairement la clé historique `FoodAndDrinks_Settings` afin de préserver les raccourcis et réglages déjà enregistrés.

## Version 1.17

- Migration non destructive des anciennes sauvegardes.
- Correction de la touche Échap et du message Alt.
- Verrouillage cohérent des suppressions et remplacements.
- Sauvegarde des positions sans écriture disque à chaque pixel déplacé.
- Restauration de la position de la fenêtre d'options.
- Validation/clamp de `/Fo repos X Y`.
- Suppression des mises à jour par frame inutiles.
- Nettoyage de l'ordre de chargement et des anciens fichiers non utilisés.
- Traductions FR/EN/DE nettoyées.
