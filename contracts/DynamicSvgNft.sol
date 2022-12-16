// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import"base64-sol/base64.sol";
  contract DynamicSvgNft is ERC721{
    uint256 private s_tokenCounter;
    // because of the images are constant we are assigning it as an immutable asset
    string private i_lowImageURI;
    string private i_highImageURI;

    AggregatorV3Interface internal immutable i_priceFeed;

    mapping (uint256 => int256) public s_tokenIdToHighValue;
    event CreatedNft(uint256 indexed tokenId,int256 indexed highValue);

    string private constant base64EncodedSvgPrefix = "data:img/svg+xml;base64,";
    constructor(address priceFeedAddress,string memory lowSvg,string memory highSvg) ERC721("DynamicSvgNft","DSN"){
        s_tokenCounter = 0;
         i_priceFeed = AggregatorV3Interface(priceFeedAddress);
        // we are getting the image uri of json formatted string
        i_lowImageURI = svgToImageURI(lowSvg);
        i_highImageURI = svgToImageURI(highSvg);
       
    }
    // this function is used to convert the svg code that is hardcoded to ipfs:// type uri
    function svgToImageURI(string memory svg)public pure returns (string memory){
        // the abi.encodePacked is an string concatination function in solidity
        // the abi converts the string into binary version of the value given and then concat it
        // since abi.encode creates a big binary file 
        // so to compress we are going to use abi.encodePacked
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(base64EncodedSvgPrefix,svgBase64Encoded));
    }

    function mintNft(int256 highValue) public{
        s_tokenIdToHighValue[s_tokenCounter] = highValue;
        
        s_tokenCounter+=1;
        _safeMint(msg.sender,s_tokenCounter);
        emit CreatedNft(s_tokenCounter,highValue);
    }
    function _baseURI()internal pure override returns(string memory){
        return  "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId)public view override returns(string memory){
        require(!_exists(tokenId),"URI Query for non-existant token");
       string memory imageURI= i_lowImageURI;
        (,int256 price, , , ) = i_priceFeed.latestRoundData();
        if(price >= s_tokenIdToHighValue[tokenId])
        {
            imageURI = i_highImageURI;
        }

        // name function is present in erc721
        // we are going to concatenate these things 
        /* we are first and foremost converting the image file into json format 
           And then after getting the json we are appending the json to the prefix from baseURI
           next we are going to typecase it by string and we return it*/
         return string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An NFT that changes based on the Chainlink Feed", ',
                                '"attributes": [{"trait_type": "coolness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
      
         
}
}