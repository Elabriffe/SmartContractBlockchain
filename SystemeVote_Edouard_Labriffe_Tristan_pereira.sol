pragma solidity ^0.4.0;
contract SystemeDeVote{
    
    struct Votant{
        address votant;
        bool avote;
        uint lenumprop;
    }
    
    struct Proposition{
        uint numeroprop;
        bytes32 nomdelaprop;
        uint nbredevote;
    }
    
    address public gerant;// celui qui va mettre toutes les propositions dans la liste et ajouter la liste de votants
    Proposition[] public prop;
    Votant[] public listevotant;
    Proposition public gagnante;
    uint numprop=0;
    
    modifier gerantOwnly(){
      if (msg.sender!=gerant) throw;
      _;
      
    }
    
    modifier VotantOnly(){
        if(msg.sender==gerant) throw;
        _;
    }
    
    function SystemeDeVote(){
        gerant=gerant;
        prop=prop;
        listevotant=listevotant;
     }
     
    function ajouterprop(bytes32 _nomprop) gerantOwnly(){
        prop.push(Proposition({nomdelaprop:_nomprop,nbredevote:0,numeroprop:numprop}));//on ajoute des propositions dans le smart contract, seul le gérant peut le faire.
        numprop++;
    }
    
    function ajoutVotant(uint _numproposition, address _votant) gerantOwnly(){//seul le gérant peut également ajouter des votants.
        listevotant.push(Votant({votant:_votant,lenumprop:0,avote:false}));
    }
    
    function AjouterUnVoteSurProposition(uint numprop) VotantOnly(){
        uint m =0;
        while(m<=listevotant.length){
            if(msg.sender==listevotant[m].votant){//si l'addresse fait partie de celle entrée par le gerant
                if(listevotant[m].avote==false){//on verifie bien que le votant n'a pas déjà voté
                    listevotant[m].lenumprop=numprop;// on attribute au votant pour quelle proposition il vote
                    listevotant[m].avote=true;// on dit si le votant a voté ou nom.
                    prop[numprop].nbredevote++;//on ajoute a la proposition +1 vote.
                }
            }
        }
        
    }
  
    function PropGagnante(){// fonction pour trouver la proposition gagnante.
        uint i=0;
        uint _maxdevote=0;
        _maxdevote=prop[0].nbredevote;
        while(i<=prop.length)//boucle pour trouver la proposition gagnante
        {
            if(prop[i].nbredevote>=_maxdevote){//on trouve la proposition avec le plus de vote
                _maxdevote=prop[i].nbredevote;
            }
          i=i+1;  
        }
        if(prop[i].numeroprop==i){
            gagnante=prop[i]; // on met la proposition gagnante dans la variable que l'on avai créer pour au début.
        }
    }
    
    
    event finvote(uint Tempsfindevote);
    function kill(){
        if (msg.sender == gerant) suicide (gerant);
        
    }
    
}