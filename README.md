# myVL
Application de vie lycéenne inititée dans le cadre de notre projet d'ISN de Terminale
<br><br>
/!\ L'application n'a jamais été testée sur iOS faute de matériel Apple dans notre équipe,
elle n'est donc pas encore fonctionnelle sur cette plateforme /!\
<br><br>
L'application a été développée majoritairement sur l'émulateur du Google Pixel 2XL, il vous garantira la meilleure expérience (plus globalement, le design de l'application est pensée davantage pour les écrans 'longs', au ratio 18/9, mais il existe parfois des conflits que nous n'avons pas encore réglés au niveau des UI overlays de ces téléphones)

## Commencer

### Prérequis

- [Clonez](https://help.github.com/en/articles/cloning-a-repository) ou téléchargez le répertoire GitHub de MyVL dans un dossier de votre ordinateur

- Pour pouvoir exécuter l'application, il est nécessaire de télécharger la [librairie Flutter](https://flutter.dev/docs/get-started/install), suivez ensuite les indications sur la page d'installation

- Placez le dossier Flutter dans le dossier où vous avez cloné ou téléchargé le projet MyVL

- Nous avons utilisé [Visual Studio Code](https://code.visualstudio.com/) pour développer l'application, l'intégration de Flutter à l'aide du [plug in dédié](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) est parfaite, nous vous le recommandons pour lire le code et exécuter l'app (à l'aide de F5 une fois dans l'IDE)


### Lancement sur un émulateur Android (Google Pixel 2XL recommandé)

- Dans le cas où vous n'avez pas d'appareil Android à disposition il est possible d'installer des émulateurs à l'aide d'[Android Studio](https://developer.android.com/studio/install)

- Il sera ensuite nécessaire de permettre à l'émulateur de recevoir des données de votre ordinateur, en suivant ces instructions :

    • Set and run the device normally

    • Turn on the developper features : go to the settings, then *System*, *About Emulated Device*, tap 5 times on *Build Number*

    • Go back, reveal the advanced options, then go to *Developper Options*

    • Make sure *USB debugging* is on

    • Find *default USB configuration*

    • Clic on it, it will open a menu, then select *File Transfer* instead of *No data transfer*

    • Open your PowerShell (or cmd, or what you want) with the emulator still opened and check if it's getting recognized with  ```flutter doctor``` or ```flutter devices```
    
    • Go to your project folder with ```cd [your folder's path]```

    • Type ```flutter run``` to launch your app in the emulator


- La commande ```flutter run``` exécute l'application, c'est l'équivalent manuel d'un appui sur la touche F5 dans Visual Studio Code avec le plugin dédié
- Cette commande lance l'application en ```debug-mode``` (unique mode possible sur émulateur)


### Lancement sur un téléphone Android physique

- Pour voir les performances réelles de l'application dans le cas d'une exécution sur un téléphone Android,
exécutez la commande :
```
flutter run --profile
```
- Assurez vous que le mode "Deboggage USB" est bien activé dans les options développeur
- Assurez vous que votre téléphone est bien en mode "Transfert de fichiers" et non pas "Charge Uniquement"
- Soyez vigilant, votre téléphone devrait vous demander l'autorisation d'installer l'application, si vous manquez la notification, l'installation sera impossible

## Tester l'application
- Vous pouvez vous inscrire en cliquant sur *Commencer* en bas de l'écran d'accueil
- Entrez l’email et le mot de passe de votre choix puis entrez les informations suivantes :
*(seuls les élèves présents dans la base de donnée peuvent s’inscrire sur l’application)*
```
Prénom: Test
Nom: Test
Établissement: [au choix] 
Classe: [au choix]
```
Vous voici dans MyVL, pour accéder au menu latéral glissez votre doigt vers la droite. Nous vous laissons à présent découvrir les différentes fonctionnalités de notre application et restons à votre disposition si vous avez des questions. 

## Contacts
* Joséphine Bourrumeau - *Auteur/Développeur* - bourrumeau.josephine@gmail.com
* Mathis Ndiaye - *Auteur/Développeur* - mathis.ndiaye@lilo.org
* Laurent Renaud - *Responsable Projet* - laurent.renaud@ac-versailles.fr

