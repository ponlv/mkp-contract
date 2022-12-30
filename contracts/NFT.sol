// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract NFT is ERC721URIStorage, ERC721Burnable,VRFConsumerBaseV2, Ownable
{
    using SafeMath for uint256;

    VRFCoordinatorV2Interface COORDINATOR;
    IERC20           immutable USDT;


    uint256 public constant NFTPrice = 1000000000000000000;
    bool public lockUserMint;
    uint256 public tokenCounter;
    mapping (uint256 => Request) public requests;
    mapping (uint256 => MeowType) public meowTypes;

    // Chainlink subscription ID
    uint64 s_subscriptionId;

    // see https://docs.chain.link/docs/vrf/v2/supported-networks/#configurations
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;

     // see https://docs.chain.link/docs/vrf/v2/supported-networks/#configurations
    bytes32 keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

    uint32 callbackGasLimit = 100_000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // For this example, retrieve 1 random value in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords = 1;

    struct Request {
        address sender;
        uint256 requestId;
    }

    enum MeowType {
        TUN,
        MIT
    }

    constructor(
        address _usdtToken
    )  ERC721("Tun&Mit NFT", "Tun&Mit") VRFConsumerBaseV2(vrfCoordinator) {
        USDT = IERC20(_usdtToken);
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    }

    modifier whenNotLockMinted() {
        require(!lockUserMint, "Lock mint by user.");
        _;
    }
    
    function buyNFT(address _ref) external whenNotLockMinted {       
        require(msg.sender != _ref, "sender and ref must be different");
        require(!lockUserMint, "LOCK_MINT");

        USDT.transferFrom(msg.sender, address(this), NFTPrice);

        // request random number from Chainlink
        uint256 requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        // save request info
        requests[requestId] = Request(msg.sender, requestId);
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {

        uint256 randomWord = randomWords[0];

        MeowType _meowType = MeowType(randomWord % 2);

        uint256 tokenId = getTokenCounter();
        meowTypes[tokenId] = _meowType;
        
        // mint NFT
        _safeMint(requests[requestId].sender, tokenId);
        // set token URI

    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage ) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage ) returns (string memory)  {
        return super.tokenURI(tokenId);
    }

    function getTokenCounter() internal returns (uint256) {
        tokenCounter = tokenCounter.add(1);
        return tokenCounter;
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId,
        uint256 _batchSize
    ) internal override(ERC721)  {
        super._beforeTokenTransfer(_from, _to, _tokenId, _batchSize);
    }
}
