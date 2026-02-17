# 🛡️ SilverBuild

**L'alliance parfaite entre Fedora Silverblue et BlueBuild, taillée sur mesure pour mes besoins (Développement & Gaming).**

Ce dépôt génère une image système immuable, basée sur Fedora 43, incluant des optimisations pour le jeu (pilotes manette Xbox Elite en Bluetooth, MangoHud) et un environnement de terminal productif (Bling, Starship, Zoxide).

---

## 🚀 Installation (Rebase)

Pour installer SilverBuild sur une machine Fedora Atomic (Silverblue, Kinoite, Bazzite...) existante, suivez ces étapes dans votre terminal :

### 1. Rebase initial (Image non-signée)
Cette première étape permet de récupérer les clés de signature et les politiques de sécurité de SilverBuild :

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/0xreaven/silverbuild:latest
```

### 3. Premier Redémarrage

Appliquez la nouvelle image de base :

```
systemctl reboot
```

### 4. Rebase final (Image signée)

Une fois redémarré sur SilverBuild, verrouillez la sécurité en passant sur l'image officiellement signée par le dépôt GitHub :

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/0xreaven/silverbuild:latest
```

### 5. Redémarrage Final

```
systemctl reboot
```

## 🛠️ Post-Installation & Automatisation (Commandes Just)

SilverBuild intègre des raccourcis natifs pour configurer l'environnement en quelques secondes grâce à l'outil ujust.
La commande magique tout-en-un

Une fois l'installation terminée, ouvrez un terminal et lancez la configuration globale de l'utilisateur :

```
ujust setup-silverbuild
```

    Note : Cette commande va automatiquement copier les fichiers de configuration par défaut vers votre /home et installer le pilote local xpadneo pour la manette Xbox.

### Gérer le Secure Boot (Important pour xpadneo)

Si le Secure Boot est activé sur votre carte mère, vous devez enregistrer la clé système pour autoriser le pilote Bluetooth de la manette :

```
ujust enroll-secure-boot-key
```

(Au redémarrage, choisissez **Enroll MOK** dans l'écran bleu).

## Commandes individuelles disponibles

Si vous avez besoin de lancer une action spécifique plus tard, ces commandes sont intégrées au système :

```
ujust reset-gnome
```

Réinitialise complètement les paramètres GNOME de l'utilisateur (dconf).

```
ujust copier-skel
```

Force la copie des fichiers de /etc/skel vers le répertoire ~ (Home).

```
ujust installer-xpadneo
```

Installe le pilote Bluetooth pour la Xbox Elite Series 2 en tant que couche locale (overlay).

## 🙏 Remerciements & Crédits

SilverBuild ne serait pas possible sans le travail colossal des communautés open source suivantes. Si vous aimez ce projet, soutenez les fondations qui le rendent possible :

* **[Le Projet Fedora](https://fedoraproject.org/)** : Pour la base de code Silverblue solide comme le roc et l'architecture OSTree qui rend l'immuabilité possible.
* **[Universal Blue (Ublue)](https://universal-blue.org/)** : Pour avoir démocratisé l'utilisation des images OCI bootables et créé les fondations de l'écosystème moderne.
* **[BlueBuild](https://blue-build.org/)** : Pour le moteur de compilation incroyablement puissant et les modules YAML qui permettent de forger des OS sur mesure directement sur GitHub.
* **[Bazzite](https://bazzite.gg/)** : Pour l'inspiration gaming, les astuces d'optimisation (MangoHud, ujust) et l'intégration des pilotes manettes.
* **[Bluefin](https://projectbluefin.io/)** : Pour l'approche orientée développeur et l'intégration parfaite de l'expérience GNOME "zéro friction".