```
1. we have to make nft contract:
i> Where people can request to mint Nft
ii> to mint they have to pay some mintFee
iii> we are going to create nft of doggies where we have 3 doggie nft images
iv> pug is the doggie which is rear and bathsheba is medium rare and torront is a common minted doggie
v> we have to make random assumptions using vrf chainlink same as raffle project

2> Deploying our nft
i> we are deploying as same as raffle contract
ii> but here we need to have IPVFS image doggies link created first
iii> once we created our own IPVFS doggies we can use them as our minting object
iv> Pinata is the service we are using to pin data
v> Pinata is also a IPFS NODE
vi> open the Api in Pinata which is present in the settings section along with it open the docs of pinata
vii> Open the pinata Nodejs sdk which is where we are going to work Link:https://www.npmjs.com/package/@pinata/sdk
viii> we are going to use pinfiletoipfs and pinjsontoipfs
ix> to work with paths we are going to use : yarn add --dev path



```
