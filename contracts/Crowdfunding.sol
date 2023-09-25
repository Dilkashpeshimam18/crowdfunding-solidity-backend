// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        string image;
        uint target;
        uint deadline;
        uint amountCollected;
        address[] donators;
        uint[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint public totalCampaigns = 0;

    event Deadlinelogged(uint indexed campaignIndex, uint deadline);

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _desc,
        string memory _image,
        uint _target,
        uint _deadline
    ) public returns (uint) {
        Campaign storage campaign = campaigns[totalCampaigns];
        emit Deadlinelogged(totalCampaigns, _deadline);

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _desc;
        campaign.image = _image;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;

        totalCampaigns++;

        return totalCampaigns - 1;
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        //creating empty array  with total number of campaign
        Campaign[] memory allCampaign = new Campaign[](totalCampaigns);

        for (uint i = 0; i < totalCampaigns; i++) {
            Campaign storage campaign = campaigns[i];
            allCampaign[i] = campaign;
        }

        return allCampaign;
    }

    function donateToCampaign(uint256 _id) public payable {
        uint amount = msg.value;

        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getAllDonators(
        uint256 _campaignId
    ) public view returns (address[] memory, uint[] memory) {
        Campaign storage campaign = campaigns[_campaignId];

        return (campaign.donators, campaign.donations);
    }
}
