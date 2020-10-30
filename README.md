# Projet DSIA_4101C R

Projet R shiny dashboard : Analyse des données de satisfaction de vie par rapport aux pays, aux années, et à d'autres données complémentaires

Introduction :
Ce projet a pour but d'intégrer dans un dashboard trois éléments graphiques permettant de comparer les différents pays du monde :
-Un graphe comparant une donnée choisie par l'utilisateur à la satisfaction de vie dans les pays
-Un histogramme comptant une donnée pour tous les pays pour une année choisie
-Une carte choroplète qui montre les différents niveaux de données dans chaque pays pour une année choisie

Lien du dataset : https://ourworldindata.org/

User's Guide :
Pour démarrer l'application, il faut avoir dans le même dossier :
-Les fichiers global.R, ui.R, server.R;
-Le dossier data_world contenant les fichiers csv;
-Le fichier world.json pour la carte;

Pour avoir le dashboard décrit ci-dessus, il faut exécuter le fichier global.R.
Différents packages sont utilisés : shiny, dplyr, ggplot2, tidyr, readr, gridExtra, shinyWidgets, countrycode, leaflet, geojsonio, geojsonR, rgdal, spdplyr, geojsonio, rmapshaper, jsonlite, maps.
L'installation de es packages peut être faite automatiquement en décommentant les premières lignes d'installation de le global.R où être installé dans l'environnement R en utilisant
la commande install.packages("XXX") où XXX est le nom du package à installer.

Developper's Guide :
Le fichier global.R fait toutes les opérations d'initialisation dont nous avons besoin ainsi que les opérations de mise en forme des données. Si l'on veut ajouter des données à exploiter, il suffit de
télécharger le fichier csv et de le mettre dans le dossier data_world. Il suffit ensuite de mettre le fichier csv avec ses colonnes dans cet ordre : Entity,Code,Year,Value. Le fichier sera ensuite
automatiquement traité dans les fonctions du serveur et sera visible dans le menu déroulant "Choose a file to use". Le fichier ui.R contient toutes la mise en forme du dashboard et le fonctionnement de ses
menu déroulants. Quant au fichier server.R, il contient tout le traitement des données et des dataframes permettant l'affichage.

Analyse des résultats :
L'objectif de notre projet était de comprendre ce qui pouvait rendre la population d'un pays à être heureuse. Pour déterminer cela nous avons utilsé la "Life satisfaction in Cantril Ladder"
Cette échelle allant de 0 à 10 permet de classifier les pays du monde en prenant 10 comme le maximum de bonheur et 0 comme le minimum. On peut donc considérer un pays ayant un score de 5
comme moyennement heureux, en dessous de 5, le pays se rapproche d'un état de malheur, et, à l'inverse, en se rapprochant de 10, un pays se rapproche d'un état de bonheur.
Avec les fichiers que nous avons choisis d'utiliser, nous pouvons montrer des corrélations entre différents critères. En exploitant les graphiques du premier onglet de notre
dashboard, on peut tenter de définir une courbe des tendances entre la variable étudiée et la variable principale que nous utilisons : la satisfaction de vie (le bonheur dans un pays).
Nous pouvons ainsi montrer que la bonheur dans un pays est impacté par plusieurs critères. Il est fortement impacté négativement par le nombre d'heures de travail et est faiblement impacté
positivement par la liberté économique du pays. Il est fortement impacté par l'espérance de vie moyenne dans un pays. On voit ensuite que l'indice de développement humain est fortement corrélé
au niveau de bonheur. On en déduit donc que le PIB par habitant, l'espérance de vie à la naissance et le niveau d'éducation des enfants de 17 ans et plus impactent tous fortement le niveau
de satisfaction d'un pays. On voit aussi que le régime politique n'impact pas le niveau de satisfaction d'un pays. Enfin la consommation d'énergie d'un Etat impact peu la satisfaction
(même si visiblement plus la consommation est élevée plus le pays est considéré comme heureux).