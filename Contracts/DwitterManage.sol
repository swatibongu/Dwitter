 pragma solidity ^0.8.0;
    import "./DwitterMain.sol";

    contract DwitterManage is DwitterMain {
        //upvote, report, delete functionalities
    //include display function
    uint256 MAX_INT = 2**256 - 1;
    event upvoted(uint id, address upvoter);
        event downvoted(uint id, address downvoter);
    event reported(uint id, address reporter);
    event deleted(uint id, uint timestamp);
    event followed(uint followers, uint following);
    
    modifier onlyAuthor(uint id) {
        require(msg.sender == dweetToAuthor[id]);
        _;
    }
    
    function getUpvotesList(address user) view public returns(uint[] memory ids) {
        return upvotesList[user];  
    }

    function getReportsList(address user) view public returns(uint[] memory ids) {
        return reportsList[user];  
    }

    function upvoteDweet(uint id) userExists public {
        dweets[id].upvotes++;
            upvotesList[msg.sender].push(id);
        emit upvoted(id, msg.sender);  
    }  

    
    function downvoteDweet(uint id) userExists public {
        dweets[id].upvotes--;
        uint[] memory temp = getUpvotesList(msg.sender);
        for(uint i=0; i<temp.length; i++){
            if(temp[i] == id){
                upvotesList[msg.sender][i] = MAX_INT;
            }
        }
        emit downvoted(id, msg.sender);    
    }  
    
        function reportDweet(uint id) userExists public {
        dweets[id].reports++;
        reportsList[msg.sender].push(id);
        emit reported(id, msg.sender);
        if(dweets[id].reports > 10){
            dweets[id].deleted = true;
        }
    }  
    

    function deleteDweet(uint id) onlyAuthor(id) public {
        dweets[id].deleted = true;
        emit deleted(id, block.timestamp);
    }
    
    
    function search(string memory _userName) userNameExists(_userName) view public returns(string memory _firstname, string memory _lastName, address pkey, string memory _bio, uint followers, uint following){
        uint id1= userNameToId[_userName];
        return(users[id1].firstname, users[id1].lastname, users[id1].pkey, users[id1].bio, users[id1].followers, users[id1].following);
    }
    
    function followUser(uint id) userExists  public {
        address toBeFollowed1= users[id].pkey;
        require(msg.sender != toBeFollowed1);
        users[id].followers++;

        uint id1 = addressToId[msg.sender];
        users[id1].following++;
        emit followed(users[id].followers, users[id1].following);
    }
    }