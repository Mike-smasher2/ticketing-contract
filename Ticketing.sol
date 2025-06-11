// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Ticketing {
    address public eventowner;

    constructor() {
        eventowner = msg.sender;
    }

    struct Ticket {
        uint256 id;
        string eventname;
        uint256 price;
        address owner;
        bool isUsed;
        Ticketstatus status;
    }
    enum Ticketstatus {
        AVAILABLE,
        PURCHASED,
        USED
    }
    
    mapping(address => Ticket[]) userToTickets;

    modifier onlyeventOwner {
        require(msg.sender == eventowner, "Not the contract owner");
        _;
    }

    function createticket(string memory _eventname, uint256 _price) public {
        Ticket[] storage userTicket = userToTickets[msg.sender];
        uint256 id = userTicket.length;

        Ticket memory newTicket = Ticket({
            id: id,
            eventname: _eventname,
            price: _price,
            owner: msg.sender,
            isUsed: false,
            status: Ticketstatus.AVAILABLE
        });
        userTicket.push(newTicket);
    }

    function Buyticket(uint256 _ticketId) public payable {
        Ticket storage userTicket = userToTickets[msg.sender][_ticketId];

        require(
            msg.value >= userToTickets[msg.sender][_ticketId].price,
            "Not enough eth sent"
        );
        require(
            userTicket.status == Ticketstatus.AVAILABLE,
            "Ticket already purchesd"
        );

        userTicket.owner = msg.sender;
        userTicket.status = Ticketstatus.PURCHASED;
        userToTickets[msg.sender].push(userTicket);
    }

    function useTicket(uint256 _ticketId) public {
        Ticket storage ticket = userToTickets[msg.sender][_ticketId];

        require(ticket.owner == msg.sender, "Not Yours");
        require(
            ticket.status == Ticketstatus.AVAILABLE,
            "Ticket not AVAILABLE"
        );

        userToTickets[msg.sender].push(ticket);
        ticket.status = Ticketstatus.USED;
    }

    function getTickets() public view returns (Ticket[] memory) {
        return userToTickets[msg.sender];
    }
}
