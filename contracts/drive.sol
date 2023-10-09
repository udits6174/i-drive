// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract drive {
    struct viewAccess{
        address user;
        bool access;
    }
    mapping (address => string[]) userData; //add to URI
    mapping(address=>mapping(address=>bool)) ownership; 
    mapping (address => viewAccess[]) accessList;

    function unchecked_inc(uint i) internal pure returns (uint) {
        unchecked {
            return i + 1;
        }
    }

    function addURI(address _user, string memory _uri) external {
        userData[_user].push(_uri);
    }

    function giveAccess(address _user) external {
        ownership[msg.sender][_user]=true; 
        uint size = accessList[msg.sender].length;
        int userIndex = -1;
        for(uint i; i<size;){
            if(accessList[msg.sender][i].user == _user){
                userIndex = int(i);
                }
            unchecked { ++i; }
        }
        if(userIndex == -1)
            accessList[msg.sender].push(viewAccess(_user, true));
        else
            accessList[msg.sender][uint(userIndex)].access == true;
    }

    function revokeAccess(address _user) external {
        ownership[msg.sender][_user]=false; 
        uint size = accessList[msg.sender].length;
        for(uint i; i<size;){
            if(accessList[msg.sender][i].user == _user){
                accessList[msg.sender][i].access = false;
                }
            unchecked { ++i; }
        }
    }
    
    function display(address _user) view external returns (string[] memory){
        require(msg.sender == _user || ownership[_user][msg.sender], "Not author");
        return userData[_user];
    }

    function viewAccessList() external view returns (address[] memory) {
        uint256 size = accessList[msg.sender].length;
        uint256 trueCount = 0;

        // Count the number of elements with access set to true.
        for (uint256 i = 0; i < size;) {
            if (accessList[msg.sender][i].access) {
                trueCount++;
            }
            unchecked { ++i; }
        }

        address[] memory arr = new address[](trueCount);

        uint256 index = 0;
        for (uint256 i = 0; i < size;) {
            if (accessList[msg.sender][i].access) {
                arr[index++] = accessList[msg.sender][i].user;
            }
            unchecked { ++i; }
        }

        return arr;
}
    
}