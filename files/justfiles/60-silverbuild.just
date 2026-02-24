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

# Rend le démarrage 100% silencieux (Masque le texte et affiche le logo OEM)
setup-silent-boot:
    #!/usr/bin/bash
    set -euo pipefail
    echo "🤫 Configuration du démarrage silencieux..."
    
    # 1. On cache le menu GRUB (au cas où ce n'est pas fait)
    sudo grub2-editenv - set menu_auto_hide=1
    
    # 2. On réduit le temps d'attente fantôme à 0
    sudo grub2-editenv - set timeout=0
    
    # 3. On ajoute les paramètres de silence au noyau (sans casser l'image)
    echo "⚙️ Ajout des paramètres silencieux au noyau..."
    rpm-ostree kargs --append-if-missing=quiet --append-if-missing=rhgb --append-if-missing=rd.udev.log_level=3
    
    echo -e "✅ \033[32mDémarrage silencieux activé !\033[0m"
    echo "⚠️ Comme on a modifié le noyau, il faut redémarrer pour appliquer."

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
# 🎮 GAMING & AFFICHAGE
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

# Configure le service Sunshine pour le streaming local (et ouvre les ports)
setup-sunshine:
    #!/usr/bin/bash
    set -euo pipefail
    echo -e "\033[1mConfiguration de Sunshine (Streaming Local)\033[0m"
    read -p "Voulez-vous (A)ctiver ou (D)ésactiver le service en arrière-plan ? " choice
    case "$choice" in
        A|a)
            echo "🔓 Ouverture des ports du pare-feu pour Sunshine..."
            sudo firewall-cmd --permanent --add-port=47984-47990/tcp
            sudo firewall-cmd --permanent --add-port=48010/tcp
            sudo firewall-cmd --permanent --add-port=47998-48000/udp
            sudo firewall-cmd --permanent --add-port=48002/udp
            sudo firewall-cmd --reload
            echo "🚀 Activation du service Sunshine..."
            systemctl enable --user --now sunshine-kms.service
            echo -e "✅ \033[32mSunshine est activé et les ports sont ouverts !\033[0m"
            echo "👉 Tu peux y accéder via https://localhost:47990"
            ;;
        D|d)
            echo "🛑 Désactivation du service Sunshine..."
            systemctl disable --user --now sunshine-kms.service
            echo "🔒 Fermeture des ports du pare-feu..."
            sudo firewall-cmd --permanent --remove-port=47984-47990/tcp
            sudo firewall-cmd --permanent --remove-port=48010/tcp
            sudo firewall-cmd --permanent --remove-port=47998-48000/udp
            sudo firewall-cmd --permanent --remove-port=48002/udp
            sudo firewall-cmd --reload
            echo -e "❌ \033[31mSunshine est désactivé et les ports sont refermés.\033[0m"
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