pragma solidity ^0.4.0;
contract PointFidelite{
    
    struct CarteFid{
        uint numCarte;
        uint points;
    }
    
    struct Client{
        uint numCarte;
        bytes32 nomClient;
        address adresseClient;
        bool aCarte;
    }
    
    struct Caissier{
        address adresseCaissier;
        bytes32 nomCaissier;
    }
    
    Caissier[] public caissier;//adresse des caissiers qui peuvent mettre les points sur la carte
    uint numeroCarte = 2050; //affectation d'un numéro de carte, qui sera incrémenté de 1 à chaque nouvelle carte
    CarteFid[] public listeCarteFid;//Créer une liste de Carte
    Client[] public listeClient;//On crée une liste de Client
    address public gerant;
    
    
    modifier gerantOnly(){
        if (msg.sender!=gerant) throw;
      _;
    }
    
    
    function ajoutCaissier(address _caissier, bytes32 _nomCaissier){// Dans cette fonction on ajoute des caissiers
        caissier.push(Caissier({adresseCaissier:_caissier,nomCaissier:_nomCaissier}));
    }
   
   modifier CaissierOnly(){
       uint i=0;
       while(i<=caissier.length){
        if(msg.sender != caissier[i].adresseCaissier) throw;
        _;
        i++;}
   }
    
    function PointFidelite(){//Le constructeur du smartcontract pour initialiser nos contrats
        gerant=gerant;
        listeCarteFid=listeCarteFid;
        listeClient=listeClient;
        caissier=caissier;
     
    }
    
    function ajoutClient(bytes32 nomDuClient, address adresseDuClient) gerantOnly(){//on va ajouter un client
            listeClient.push(Client({numCarte:numeroCarte,nomClient:nomDuClient,adresseClient:adresseDuClient,aCarte:true}));
            numeroCarte++;
    }
    
    function ajoutCarte() CaissierOnly(){//seulement s'il s'agit du caisier qui effectue la création
        uint k=0;
        uint numCarte=0;
        uint i=0;
        while(k<=listeClient.length){
            if(listeClient[k].aCarte==true){// si le client a une carte  alors on va récupérer son numéro
                numCarte=listeClient[k].numCarte;
                listeCarteFid.push(CarteFid({numCarte:numeroCarte,points:0}));//
            }
            k++;
        }
    }
    
    function ajouterPointsCarte(bytes32 nomClient, uint nbPoints)CaissierOnly(){
        uint i = 0;
        uint j =0;
        uint numCarte=2050;
        while(j<=listeClient.length){// On cherche d'abord le nom du client et on récupère son numéro de carte
            if(listeClient[j].nomClient==nomClient){
                numCarte=listeClient[j].numCarte;
            }
            j++;
        }
        while(i<=listeCarteFid.length){// dans cette boucle on ajoute les points sur la carte du client
            if(listeCarteFid[i].numCarte==numCarte){
                listeCarteFid[i].points = listeCarteFid[i].points + nbPoints;
            }
            i++;
        }
    }
    
    function EnleverPointsCarte(uint numero, uint nbPoints) CaissierOnly(){
        uint i = 0;
        while(i<=listeCarteFid.length){// Cette fonction permet d'enlever les points sur la carte d'un client si par exemple celui-ci change de carte
            if(listeCarteFid[i].numCarte==numero)
            {
                if(listeCarteFid[i].points>nbPoints)
                {
                    listeCarteFid[i].points = listeCarteFid[i].points - nbPoints;
                }
            }
            i++;
        }
    }
    
    event Pointmisurcarte(uint nbredepoint);
    event Pointsurcarteapprove(bool pointcarteok);
    
    function kill(){
        if (msg.sender == gerant){ 
        selfdestruct(gerant);
        }
    }
}
    
    