Write-Host ""
Write-Host "🚀 Générateur de clé SSH personnalisé"
Write-Host "===================================="
Write-Host ""

# Saisie des informations utilisateur
$Company = Read-Host "🏢 Entrez le nom de l'entreprise"
$FirstName = Read-Host "👤 Entrez votre prénom"
$LastName = Read-Host "👤 Entrez votre nom de famille"

# Mise en minuscules
$Company = $Company.ToLower()
$FirstName = $FirstName.ToLower()
$LastName = $LastName.ToLower()

# Construction du nom de fichier et du commentaire
$ShortUser = "$($FirstName.Substring(0,1))$LastName"     # ldiogo
$KeyFileName = "${ShortUser}_${Company}"                 # ldiogo_beelix
$KeyPath = "$env:USERPROFILE\.ssh\$KeyFileName"
$Comment = "$ShortUser@$Company"                         # ldiogo@beelix

Write-Host ""
if (-not (Get-Command "ssh-keygen" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ La commande ssh-keygen est introuvable. Veuillez l'installer d'abord."
    exit
}

if (Test-Path "$KeyPath") {
    Write-Host ""
    Write-Host "La clé $KeyFileName existe déjà. Voulez-vous la remplacer ? (o/N)"
    $response = Read-Host
    if ($response.ToLower() -ne 'o') {
        Write-Host ""
        Write-Host "❌ Opération annulée par l'utilisateur."
        exit
    }
    Remove-Item "$KeyPath" -Force
    Remove-Item "$KeyPath.pub" -Force
    Write-Host "🧹 Ancienne clé supprimée."
}

Write-Host ""
$pass1 = Read-Host "🔑 Entrez une passphrase pour sécuriser votre clé SSH" -AsSecureString
$pass2 = Read-Host "🔁 Confirmez la passphrase" -AsSecureString

$ptr1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass1)
$ptr2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass2)
$unsecure1 = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr1)
$unsecure2 = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr2)

if ($unsecure1 -ne $unsecure2) {
    Write-Host ""
    Write-Host "❌ Les passphrases ne correspondent pas. Abandon."
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr1)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr2)
    exit
} else {
    Write-Host "🔐 Passphrases confirmées ✅"
}

Write-Host ""
Write-Host "⚙️ Génération de la clé SSH..."
ssh-keygen -t ed25519 -C $Comment -f $KeyPath -N $unsecure1

[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr1)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr2)

$pubKey = Get-Content "$KeyPath.pub"

Start-Sleep -Seconds 1

Write-Host ""
Write-Host "✅ Clé SSH générée avec succès !"
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════"
Write-Host "🟡 Voici votre clé publique à transmettre :"
Write-Host ""

$pubKey | ForEach-Object {
    Write-Host "🔓 $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════"

Write-Host ""
Write-Host "🧠 Souhaitez-vous ajouter la clé à l'agent SSH ? (o/N)"
$addToAgent = Read-Host
if ($addToAgent.ToLower() -eq 'o') {
    if (Get-Service -Name ssh-agent -ErrorAction SilentlyContinue) {
        Start-Service ssh-agent | Out-Null
        ssh-add $KeyPath
        Write-Host "✅ Clé ajoutée à l'agent SSH."
    } else {
        Write-Host "❌ Le service ssh-agent n'est pas disponible sur cette machine."
    }
} else {
    Write-Host "ℹ️ Clé non ajoutée à l'agent SSH."
}

Write-Host ""
Write-Host "📁 Clé privée : $KeyPath"
Write-Host "📁 Clé publique : $KeyPath.pub"
Write-Host ""
Write-Host "⏎ Appuyez sur Entrée pour quitter..."
Read-Host
