import { getSuperBridgeAddresses } from "../helpers";
import { Contract } from "ethers";
import {
  getProviderFromChainSlug,
  getSignerFromChainSlug,
} from "../helpers/networks";
import { isSBAppChain } from "../helpers/projectConstants";
import { BRIDGED_TOKEN_ABI } from "../constants/abis";

const role =
  "0x52ba824bfabc2bcfcdf7f0edbb486ebb05e1836c90e78047efeb949990f72e5f";

export const main = async () => {
  try {
    const addresses = getSuperBridgeAddresses();
    for (const chain of Object.keys(addresses)) {
      console.log(`\nChecking addresses for chain ${chain}`);
      for (const token of Object.keys(addresses[chain])) {
        if (!isSBAppChain(+chain, token)) continue;

        const tokenAddress = addresses[chain][token].MintableToken;
        const controller = addresses[chain][token].Controller;
        const mintable = new Contract(
          tokenAddress,
          BRIDGED_TOKEN_ABI,
          getSignerFromChainSlug(+chain)
        );

        const hasRole = await mintable.callStatic.hasRole(role, controller);

        if (hasRole) {
          console.log(
            `Controller (${controller}) for ${token} (${tokenAddress}) on chain ${chain} has role`
          );

          continue;
        }

        const promisedTransaction = await mintable.grantRole(role, controller);

        const finalizedTransaction = await promisedTransaction.wait();

        console.log(
          `Controller (${controller}) for ${token} (${tokenAddress}) on chain ${chain} has role with tx ${finalizedTransaction.hash}`
        );
      }
    }
  } catch (error) {
    console.error("Error while checking minter", error);
  }
};

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
