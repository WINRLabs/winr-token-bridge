import {
  ChainSlug,
  DeploymentMode,
  IntegrationTypes,
} from "@socket.tech/dl-core";
import { Hooks, ProjectConstants } from "../../../../src";
import { Tokens } from "../../../../src/enums";

// For testnet deployments, ChainSlug enum may not have some chains, therefore some keys will look like {421614:{}} instead of {[ChainSlug.ARBITRUM_SEPOLIA]:{}}. This wont affect the functionality of the project.
export const pc: ProjectConstants = {
  [DeploymentMode.PROD]: {
    [Tokens.USDCE]: {
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.USDC]: {
      vaultChains: [
        ChainSlug.ARBITRUM,
        ChainSlug.MAINNET,
        ChainSlug.BSC,
        ChainSlug.BASE,
      ],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.WETH]: {
      vaultChains: [ChainSlug.ARBITRUM, ChainSlug.MAINNET, ChainSlug.BASE],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.WBTC]: {
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.USDT]: {
      vaultChains: [
        ChainSlug.ARBITRUM,
        ChainSlug.MAINNET,
        ChainSlug.BSC,
        ChainSlug.BASE,
      ],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.ETH]: {
      vaultChains: [
        ChainSlug.ARBITRUM,
        ChainSlug.MAINNET,
        ChainSlug.BASE,
        ChainSlug.BSC,
      ],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.ARB]: {
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.VWINR]: {
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.BOOP]: {
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.SPX]: {
      vaultChains: [ChainSlug.BASE, ChainSlug.MAINNET],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.BRETT]: {
      vaultChains: [ChainSlug.BASE],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.TOSHI]: {
      vaultChains: [ChainSlug.BASE],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.PEPE]: {
      vaultChains: [ChainSlug.MAINNET],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.MOG]: {
      vaultChains: [ChainSlug.MAINNET, ChainSlug.BASE],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.SHIB]: {
      vaultChains: [ChainSlug.MAINNET],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
  },
};
