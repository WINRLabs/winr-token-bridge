import {
  ChainSlug,
  DeploymentMode,
  IntegrationTypes,
} from "@socket.tech/dl-core";
import { Hooks, ProjectConstants } from "../../../../src";
import { Tokens } from "../../../../src/enums";

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
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.WETH]: {
      vaultChains: [ChainSlug.ARBITRUM],
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
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
    [Tokens.ETH]: {
      vaultChains: [ChainSlug.ARBITRUM],
      controllerChains: [ChainSlug.WINR],
      hook: {
        hookType: Hooks.NO_HOOK,
      },
    },
  },
};
