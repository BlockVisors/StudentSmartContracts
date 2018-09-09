pragma solidity ^0.4.24;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDepoyedCampaigns() public view returns (address[]) {
    //public anyone can access, view no data is aleter, returns mean nwe are 
    //returng a value of type address array
    return deployedCampaigns;
    }
}

contract Campaign {
    // this is just a definition...this does not create an instance of the object
    
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        //we dont have to initialize reference type below
        mapping(address => bool) approvals;
        
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }
    
    // money needs payable
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
    approvers[msg.sender] = true;
    approversCount++;
    
    }
    
    
    //make sure to pass the arguments
    function createRequest(string description, uint value, address recipient) 
        public restricted {
            //use this require to see if the sender is in the group of approvers
            
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });
        // // alt syntax for using struct
        // //this is based in consistent order of arguments
        // Request(description, value, recipient, false);
        
        requests.push(newRequest);
    }
    
    //need to pass in the index to approve
    function approveRequest(uint index) public {
       // Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        //kick the user out if false
        require(!requests[index].approvals[msg.sender]);
        
        requests[index].approvals[msg.sender] = true;
        requests[index].approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted {
        // call the struct instance and you can simple call request
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
        
    }
}