//SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Voting{

    uint noOfVoters; // Number of Voters
    uint noOfCandidates;
    
    address admin;
    
  
    struct Candidate{
        string candidate_name;
        string candidate_description;
        uint noOfVotes;
    }
   
   struct Voter{
        uint candidate_id; //vote should be ano..
        bool hasVoted;
    }
    
    mapping (uint => Candidate) public candidates;
    mapping (string => Voter) voters; // one address one vote , String --> Adr and Voter --> Bool
    
    constructor(){
        admin = msg.sender;
    }
    
    modifier onlyAdmin(){
        require(msg.sender == admin,"Only Admin");
        _;
    }
    
    function candidateEnrollment(string memory name,string memory description) public onlyAdmin {
        uint candidateID = noOfCandidates++;
        candidates[candidateID] = Candidate(name,description,0);
        //Event emit
    }
    
    //vote ---> check if voted --> canditate id param

    function voterEnrollment(string memory name,uint candidateID) public  returns(string memory){
        require(voters[name].hasVoted == false);
        ++noOfVoters;
        voters[name] = Voter(candidateID,true);
        candidates[candidateID].noOfVotes += 1;
        return "You have successfully voted";
    }
    function candidateIDGenerator(string memory name) public view returns(uint){
        for(uint i =0;i<noOfCandidates;i++){
            string memory findingName = candidates[i].candidate_name;
            if(keccak256(abi.encodePacked(findingName)) == keccak256(abi.encodePacked(name))){
                return i;
            }
        }
    }
    function results() public onlyAdmin view returns (string memory){
        uint maxVotes = candidates[0].noOfVotes;
        uint candidateID;
        for(uint i = 0 ; i<noOfCandidates;i++) {
            if(maxVotes < candidates[i].noOfVotes) {
                maxVotes = candidates[i].noOfVotes;
                candidateID = i;
            }
        }
        return (candidates[candidateID].candidate_name);
    }
}
