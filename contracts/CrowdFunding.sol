// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
  struct Campaign {
    address owner;
    string title;
    string description;
    uint256 target;
    uint256 deadline;
    uint256 amountCollected;
    string image;
    address[] donators;
    uint256[] donations; 
  }

  mapping(uint256 => Campaign) public camaigns;

  uint256 public numberOfCampaigns = 0;

  function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns(uint256){

    Campaign storage camaign = camaigns[numberOfCampaigns];

    require(camaign.deadline < block.timestamp, "the deadline should be a date in the future.");

    camaign.owner = _owner;
    camaign.title = _title;
    camaign.description = _description;
    camaign.target = _target;
    camaign.deadline = _deadline;
    camaign.image = _image;
    camaign.amountCollected = 0;

    numberOfCampaigns++;

    return numberOfCampaigns - 1;
  }
  function donateToCampaign(uint256 _id) public payable{
    uint256 amount = msg.value;
    Campaign storage camaign = camaigns[_id];

    camaign.donators.push(msg.sender);
    camaign.donations.push(amount);

    (bool sent,) = payable(camaign.owner).call{value: amount}("");
    if (sent) {
      camaign.amountCollected = camaign.amountCollected + amount;
    }
  }
  function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory ){
    return (camaigns[_id].donators, camaigns[_id].donations);
  }
  function getCampaigns() view public returns(Campaign[] memory) {
    Campaign[] memory allCampaings = new Campaign[](numberOfCampaigns);
    for(uint i = 0;i < numberOfCampaigns; i++) {
      Campaign storage item = camaigns[i];
      allCampaings[i] = item;
    }
    return allCampaings;
  }
}
