//SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Voting{
    uint noOfVoters;
    uint noOfCandidates;
    
    address admin;
    
    enum Phases {StartPhase, EnrollmentPhase, VotingPhase, ResultPhase}
    Phases electionPhases;

    struct Candidate{
        string candidate_name;
        string candidate_description;
        uint noOfVotes;
    }
   
    struct Voter{
        bool hasVoted;
        bool isValid;
    }
    
    mapping (uint => Candidate) public candidates;
    mapping (string => Voter) voters;
    mapping (address => Voter) eligibleVotersList ;
    
    constructor(){
        admin = msg.sender;
        electionPhases = Phases.StartPhase;
    }
    
    modifier onlyAdmin(){
        require(msg.sender == admin,"Only Admin");
        _;
    }
    function phaseChangeTo(uint phase) public onlyAdmin returns(string memory){
        if(phase == 0){
            electionPhases = Phases.StartPhase;
            return "Phase = StartPhase";
        }
        else if(phase == 1){
            electionPhases = Phases.EnrollmentPhase;
            return "Phase = EnrollmentPhase";
        }
        else if(phase == 2){
            electionPhases = Phases.VotingPhase;
            return "Phase = VotingPhase";
        }
        else if(phase == 3){
            electionPhases = Phases.ResultPhase;
            return "Phase = ResultPhase";
        }
        else{
            return "Enter Valid Phase";
        }
    }
    // voting phase should be there
    function candidateEnrollment(string memory name,string memory description) public onlyAdmin {
        require(electionPhases == Phases.EnrollmentPhase);
        uint candidateID = noOfCandidates++;
        candidates[candidateID] = Candidate(name,description,0);
        //Event emit
    }
    
    //vote ---> check if voted, eligible voter --> canditate id param --> Vote Struct ++ --> Bool , voting phase 
    // add voter --> admin only --> to add voter in mapping 
    // enum , enum phase change admin only function 
    function voterEnrollment(string memory name) public onlyAdmin {
        require(electionPhases == Phases.EnrollmentPhase);
        require(eligibleVotersList[msg.sender].isValid == false);
        eligibleVotersList[msg.sender].isValid == true;    

    }
    function vote(string memory name,uint candidateID) public  returns(string memory){
        require(electionPhases == Phases.EnrollmentPhase);
        require(voters[name].hasVoted == false);
        ++noOfVoters;
        voters[name] = Voter(true);
        candidates[candidateID].noOfVotes += 1;
        return "You have successfully voted";
    }
    // result end 
    function results() public onlyAdmin view returns (string memory){
        require(electionPhases == Phases.ResultPhase);
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
