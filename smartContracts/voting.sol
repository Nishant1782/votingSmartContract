//SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Voting{
    uint noOfVoters;
    uint noOfCandidates;
    address admin;
    mapping (uint => Candidate) public candidates;
    mapping (string => Voter) voters;
    struct Candidate{
        string candidate_name;
        string candidate_description;
        uint noOfVotes;
    }
    struct Voter{
        uint candidate_id;
        bool hasVoted;
    }
    constructor(){
        admin = msg.sender;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin,"Access is Denied");
        _;
    }
    function candidateEnrollment(string memory name,string memory description) public onlyAdmin returns(string memory){
        uint candidateID = noOfCandidates++;
        candidates[candidateID] = Candidate(name,description,0);
        return "You will be added to candidate list once you are validated by the admin";
    }
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