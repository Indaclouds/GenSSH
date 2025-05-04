# 🔐 GenSSH

**Générateur de clé SSH interactif** pour utilisateurs Windows, avec interface en ligne de commande enrichie (PowerShell),prise en charge de l’agent SSH et divers prérequis de sécurité.

---

## 📦 Fonctionnalités

- Génération d'une clé SSH `ed25519` avec nom personnalisé
- Saisie et confirmation sécurisée d'une passphrase
- Ajout optionnel de la clé privée à l'agent SSH (`ssh-agent`)
- Affichage de la clé publique au format prêt à copier/coller
- Interface utilisateur lisible et conviviale grâce à l'usage d'emojis

---

## 🚀 Téléchargement

👉 Téléchargez la dernière version ici :  
➡️ [Dernière version sur GitHub Releases](https://github.com/Indaclouds/GenSSH/releases/latest)

> 💡 Le fichier peut être signalé à tort par Windows SmartScreen. Si c’est le cas :
> 1. Cliquez sur **"Informations complémentaires"**
> 2. Puis sur **"Exécuter quand même"**

---

## 🛠️ Utilisation

1. Double-cliquez sur le fichier `GenSSH.exe` téléchargé
2. Suivez les instructions affichées dans la console
3. Une fois la clé générée :
   - Le fichier sera disponible dans `C:\Users\<name>\.ssh`
   - La clé publique s'affichera automatiquement et pourra être copiée

---

## 🖥️ Exigences

- ✅ Windows 10 ou supérieur
- ✅ `ssh-keygen` disponible dans le `PATH` (inclus dans Git Bash ou OpenSSH for Windows)
- ❗ L’outil est prévu pour Windows uniquement

---

## 📝 Licence

Ce projet est distribué sous licence [MIT](LICENSE).
