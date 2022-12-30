// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFT is ERC721URIStorage, ERC721Burnable, Ownable
{
    using SafeMath for uint256;

    uint256 public constant NFTPrice = 1000000000000000000;
    IERC20           immutable USDT;
    bool             public lockUserMint;


    constructor(
        address _usdtToken
    )  ERC721("Tun&Mit NFT", "Tun&Mit") {
        USDT = IERC20(_usdtToken);
    }

    modifier whenNotLockMinted() {
        require(!lockUserMint, "Lock mint by user.");
        _;
    }

    
    function buyNFT(address _ref) external whenNotLockMinted {       
        require(msg.sender != _ref, "sender and ref must be different");
        require(!lockUserMint, "LOCK_MINT");

        USDT.transferFrom(msg.sender, address(this), NFTPrice);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage ) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage ) returns (string memory)  {
        return super.tokenURI(tokenId);
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
