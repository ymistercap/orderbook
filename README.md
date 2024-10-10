Ce smart contract a été développé pour gérer un système d'orderbook décentralisé, permettant aux utilisateurs de passer des ordres d'achat et de vente. Le contrat gère automatiquement l'appariement des ordres en fonction des prix et des quantités spécifiés par les utilisateurs.

Logique du contrat

Structures de données
Order : Une structure qui représente un ordre sur l'orderbook. Chaque ordre contient les informations suivantes :

id : L'identifiant unique de l'ordre.
user : L'adresse de l'utilisateur qui a passé l'ordre.
amount : La quantité d'actif que l'utilisateur souhaite acheter ou vendre.
price : Le prix auquel l'utilisateur souhaite acheter ou vendre.
isBuyOrder : Un booléen qui indique si l'ordre est un ordre d'achat (true) ou de vente (false).
Mappings :

orders : Un mapping qui stocke tous les ordres passés par les utilisateurs, indexés par leur identifiant.
userOrders : Un mapping qui relie les adresses des utilisateurs à leurs ordres, permettant de suivre les ordres spécifiques de chaque utilisateur.
Fonctions principales
placeBuyOrder : Cette fonction permet à un utilisateur de passer un ordre d'achat. Lorsqu'un ordre est passé :

L'identifiant de l'ordre est incrémenté.
L'ordre est enregistré dans le mapping orders.
L'ordre est également enregistré dans userOrders pour référence future.
Un événement OrderPlaced est émis pour notifier le réseau.
La fonction matchOrders est appelée pour tenter d'apparier cet ordre avec des ordres de vente existants.
placeSellOrder : Similaire à placeBuyOrder, cette fonction permet aux utilisateurs de passer des ordres de vente. La logique est identique, mais les ordres sont marqués comme des ordres de vente (isBuyOrder = false).

matchOrders : Cette fonction est responsable de l'appariement des ordres d'achat et de vente. La fonction :

Parcourt tous les ordres d'achat et de vente en utilisant une double boucle.
Vérifie si le prix de l'ordre d'achat est suffisant pour couvrir le prix de l'ordre de vente.
Si une correspondance est trouvée, les quantités des ordres correspondants sont mises à jour, et un événement OrdersMatched est émis.
Si un ordre d'achat est entièrement exécuté (quantité égale à zéro), il est supprimé du mapping orders.
Couverture de code
Pour garantir que chaque partie du contrat fonctionne correctement, j'ai implémenté des tests unitaires en utilisant le framework Forge. Ces tests incluent :

testPlaceBuyOrder : Vérifie que les ordres d'achat sont correctement passés et enregistrés.
testPlaceSellOrder : Vérifie que les ordres de vente sont correctement passés et enregistrés.
testMatchOrders : Vérifie que les ordres d'achat et de vente sont correctement appariés lorsque leurs conditions de prix sont remplies.
