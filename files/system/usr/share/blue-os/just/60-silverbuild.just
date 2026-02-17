# Supprimer la configuration GNOME actuelle de l'utilisateur
reset-gnome:
    @echo "🗑️ Suppression de la configuration GNOME par défaut..."
    dconf reset -f /org/gnome/
    rm -rf ~/.config/dconf/user
    @echo "✅ Configuration GNOME réinitialisée !"

# Copier les fichiers personnalisés depuis /etc/skel
copier-skel:
    @echo "📂 Copie des fichiers depuis /etc/skel vers /home..."
    cp -a /etc/skel/. ~/
    @echo "✅ Fichiers copiés avec succès !"

# Installer le pilote Xbox Elite (xpadneo) localement
installer-xpadneo:
    @echo "🎮 Installation du pilote xpadneo..."
    rpm-ostree install xpadneo
    @echo "✅ Pilote installé !"
    @echo "⚠️ N'oublie pas de lancer 'ujust enroll-secure-boot-key' et de redémarrer."

# ==========================================
# LA COMMANDE MAGIQUE TOUT-EN-UN
# ==========================================

# Lancer toute la configuration initiale de SilverBuild d'un seul coup
setup-mon-os: reset-gnome copier-skel installer-xpadneo
    @echo "🎉 TERMINÉ ! Ton environnement est prêt."
    @echo "👉 Prochaine étape : tape 'ujust enroll-secure-boot-key', puis redémarre ton PC !"
