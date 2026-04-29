# ==================================================
# 🚀 SYSTEM & UPDATES
# ==================================================

# Met à jour tout le système (OSTree, Flatpaks)
update:
    #!/usr/bin/bash
    echo "🔄 Mise à jour de l'image système (OSTree)..."
    rpm-ostree upgrade
    echo "📦 Mise à jour des Flatpaks..."
    flatpak update -y
    echo "✅ Mise à jour terminée ! N'oubliez pas de redémarrer si l'image a changé."

# Ouverture et fermeture des ports pour GSConnect
setup-gsconnect:
    #!/usr/bin/bash
    set -euo pipefail
    echo -e "\033[1mConfiguration de GSConnect (Liaison Smartphone)\033[0m"
    read -p "Voulez-vous (O)uvrir ou (F)ermer les ports du pare-feu ? " choice
    case "$choice" in
        O|o)
            echo "🔓 Ouverture des ports pour GSConnect..."
            sudo firewall-cmd --permanent --add-service=kdeconnect
            sudo firewall-cmd --reload
            echo -e "✅ \033[32mPorts ouverts ! Ton PC est maintenant visible par ton téléphone.\033[0m"
            ;;
        F|f)
            echo "🔒 Fermeture des ports pour GSConnect..."
            sudo firewall-cmd --permanent --remove-service=kdeconnect
            sudo firewall-cmd --reload
            echo -e "❌ \033[31mPorts fermés. Ton PC est de nouveau invisible.\033[0m"
            ;;
        *) echo "Action annulée." ;;
    esac

# Restaure les configurations par défaut du système (/etc/skel)
restore-skel:
    #!/usr/bin/bash
    set -euo pipefail
    echo -e "\033[1mRestauration du dossier personnel (/etc/skel)\033[0m"
    echo "Le dossier /etc/skel contient les fichiers de configuration par défaut du système (ex: .bashrc, .config...)."
    echo ""
    read -p "Voulez-vous (M)anquants (copier sans écraser), (E)craser tout, ou (A)nnuler ? " choice
    case "$choice" in
        M|m)
            echo "📁 Copie uniquement des fichiers manquants..."
            cp -rn /etc/skel/. $HOME/
            echo -e "✅ \033[32mFichiers manquants restaurés ! Tes configurations actuelles n'ont pas été touchées.\033[0m"
            ;;
        E|e)
            echo "⚠️ Copie et écrasement des fichiers existants..."
            cp -r /etc/skel/. $HOME/
            echo -e "✅ \033[32mDossier personnel réinitialisé avec les paramètres par défaut !\033[0m"
            ;;
        *) echo "Action annulée." ;;
    esac

# ==================================================
# 🎮 GAMING
# ==================================================

# Force l'upgrade FSR 4
toggle-fsr4:
    #!/usr/bin/bash
    set -euo pipefail
    FILE="$HOME/.config/environment.d/99-proton-fsr4.conf"
    echo -e "\033[1mGlobal FSR4 (RDNA4)\033[0m"
    echo "Permet à Proton de forcer le FSR 4 sur les jeux compatibles (FSR 3.1+)."
    read -p "Voulez-vous (A)ctiver ou (D)ésactiver ? " choice
    case "$choice" in
        A|a)
            mkdir -p "$HOME/.config/environment.d"
            echo "PROTON_FSR4_UPGRADE=1" > "$FILE"
            echo -e "✅ \033[32mActivé\033[0m: PROTON_FSR4_UPGRADE=1"
            ;;
        D|d)
            rm -f "$FILE"
            echo -e "❌ \033[31mDésactivé\033[0m: PROTON_FSR4_UPGRADE retiré"
            ;;
        *) echo "Action annulée." ;;
    esac

# ==================================================
# 🍺 HOMEBREW & BBREW
# ==================================================

# Installe le wrapper bbrew
setup-brew:
    #!/usr/bin/bash
    set -euo pipefail

    echo "📦 Installation du dépôt et du paquet bbrew..."
    brew install Valkyrie00/homebrew-bbrew/bbrew

    echo -e "\n🎉 \033[32mInstallation terminée !\033[0m"
    echo "Ferme ce terminal et ouvres-en un nouveau pour utiliser la commande 'bbrew'."
