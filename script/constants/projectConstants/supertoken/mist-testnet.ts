import {
  ChainSlug,
  DeploymentMode,
  IntegrationTypes,
} from "@socket.tech/dl-core";
import { Hooks, ProjectConstants, ProjectType, Tokens } from "../../../../src";
import { getSocketOwner } from "../../config";

const pc: ProjectConstants = {
  [DeploymentMode.PROD]: {
    [Tokens.USDC]: {
      vaultChains: [ChainSlug.OPTIMISM_SEPOLIA],
      controllerChains: [
        ChainSlug.ARBITRUM_SEPOLIA,
        ChainSlug.AEVO_TESTNET,
        ChainSlug.POLYGON_MUMBAI,
      ],
      superTokenInfo: {
        name: "Mist",
        symbol: "MIST",
        decimals: 6,
        initialSupplyOwner: getSocketOwner(),
        owner: getSocketOwner(),
        initialSupply: 1000000000,
      },
      hook: {
        hookType: Hooks.LIMIT_HOOK,
        limitsAndPoolId: {
          [ChainSlug.ARBITRUM_SEPOLIA]: {
            [IntegrationTypes.fast]: {
              sendingLimit: "50000",
              receivingLimit: "50000",
            },
          },
          [ChainSlug.AEVO_TESTNET]: {
            [IntegrationTypes.fast]: {
              sendingLimit: "50000",
              receivingLimit: "50000",
            },
          },
          [ChainSlug.POLYGON_MUMBAI]: {
            [IntegrationTypes.fast]: {
              sendingLimit: "50000",
              receivingLimit: "50000",
            },
          },
          [ChainSlug.OPTIMISM_SEPOLIA]: {
            [IntegrationTypes.fast]: {
              sendingLimit: "50000",
              receivingLimit: "50000",
              poolCount: 1,
            },
          },
        },
      },
    },
  },
};

export = pc;
