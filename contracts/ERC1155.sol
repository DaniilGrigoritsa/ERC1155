// SPDX-License-Identifier: ICS
pragma solidity ^0.8.15;

import "./IERC1155.sol";


contract ERC1155 is IERC1155 {

    mapping(uint => mapping(address => uint)) private balances;

    mapping(address => mapping(address => bool)) private approvals;


    function balanceOf(address _owner, uint256 _id) public view returns (uint256){
        require((_owner) != address(0));
        return balances[_id][_owner];
    }
    

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint[] memory){
        require(_owners.length == _ids.length);

        uint[] memory _balances = new uint[](_owners.length);

        for(uint i = 0; i < _owners.length; ++i) {
            _balances[i] = balanceOf(_owners[i], _ids[i]);
        }

        return _balances;
    }

    
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external{
        require(_from == msg.sender || isApprovedForAll(_from, msg.sender));
        _safeTransferFrom(_from, _to, _id, _value, _data);
    }


    function _safeTransferFrom(address from, address to, uint id, uint amount, bytes calldata data) internal {
        require(to != address(0));

        address operator = msg.sender;

        uint fromBalance = balances[id][from];
        require(fromBalance >= amount);
        balances[id][from] = fromBalance - amount;
        balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);
    }


    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external{
        require(_values.length == _ids.length);

        for(uint i = 0; i < _values.length; ++i) {
            _safeTransferFrom(_from, _to, _ids[i], _values[i], _data);
        }
    }


    function setApprovalForAll(address owner, address operator, bool approved) external {
        require(owner != operator);
        approvals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }


    function isApprovedForAll(address _owner, address _operator) public view returns (bool){
        return approvals[_owner][_operator];
    }

}
