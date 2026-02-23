# ==================================================
# 🚀 SYSTEM & UPDATES
# ==================================================

# 🔄 Met à jour tout le système (OSTree, Flatpaks)
update:
    #!/usr/bin/bash
    echo "🔄 Mise à jour de l'image système (OSTree)..."
    rpm-ostree upgrade
    echo "📦 Mise à jour des Flatpaks..."
    flatpak update -y
    echo "✅ Mise à jour terminée ! N'oubliez pas de redémarrer si l'image a changé."

# 🧹 Nettoie le système en profondeur
clean:
    #!/usr/bin/bash
    echo "🗑️ Nettoyage des Flatpaks inutilisés..."
    flatpak uninstall --unused -y
    echo "🧹 Nettoyage du cache système..."
    rpm-ostree cleanup -m -b
    echo "✅ Système tout propre !"

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

# ==================================================
# 🎮 GAMING & AFFICHAGE
# ==================================================

# 🚀 Force l'upgrade FSR 4
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

# ☀️ Configure le service Sunshine pour le streaming local (et ouvre les ports)
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