// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./HookBase.sol";

contract DecimalHook is HookBase {
    mapping(address => uint8[]) private tokenDecimals;

    event TokenDecimalsUpdated(address indexed token, uint8[2] decimals);

    constructor(
        address owner_,
        address vaultOrController_
    ) HookBase(owner_, vaultOrController_) {}

    function getTokenDecimals(
        address connector
    ) external view returns (uint8[2] memory) {
        uint8[2] memory decimals = [
            tokenDecimals[connector][0],
            tokenDecimals[connector][1]
        ];
        return decimals;
    }

    function srcPreHookCall(
        SrcPreHookCallParams calldata params_
    )
        external
        view
        returns (TransferInfo memory transferInfo, bytes memory postHookData)
    {
        uint8 srcDecimal = tokenDecimals[params_.connector][0];
        uint8 dstDecimal = tokenDecimals[params_.connector][1];

        uint256 adjustedAmount = adjustDecimals(
            params_.transferInfo.amount,
            srcDecimal,
            dstDecimal
        );

        transferInfo = TransferInfo({
            receiver: params_.transferInfo.receiver,
            amount: adjustedAmount,
            extraData: params_.transferInfo.extraData
        });

        postHookData = hex"";
    }

    function dstPreHookCall(
        DstPreHookCallParams calldata params_
    )
        external
        view
        returns (bytes memory postHookData, TransferInfo memory transferInfo)
    {
        uint8 srcDecimal = tokenDecimals[params_.connector][0];
        uint8 dstDecimal = tokenDecimals[params_.connector][1];

        uint256 adjustedAmount = adjustDecimals(
            params_.transferInfo.amount,
            srcDecimal,
            dstDecimal
        );

        transferInfo = TransferInfo({
            receiver: params_.transferInfo.receiver,
            amount: adjustedAmount,
            extraData: params_.transferInfo.extraData
        });

        postHookData = hex"";
    }

    function srcPostHookCall(
        SrcPostHookCallParams calldata params_
    ) external view returns (TransferInfo memory transferInfo) {
        transferInfo = params_.transferInfo;
    }

    function dstPostHookCall(
        DstPostHookCallParams calldata params_
    ) external returns (CacheData memory cacheData) {
        cacheData = CacheData({
            identifierCache: params_.postHookData,
            connectorCache: params_.connectorCache
        });
    }

    function preRetryHook(
        PreRetryHookCallParams calldata params_
    )
        external
        returns (bytes memory postHookData, TransferInfo memory transferInfo)
    {
        postHookData = hex"";
        transferInfo = TransferInfo({
            receiver: address(0),
            amount: 0,
            extraData: hex""
        });
    }

    function postRetryHook(
        PostRetryHookCallParams calldata params_
    ) external returns (CacheData memory cacheData) {
        cacheData = CacheData({
            identifierCache: params_.postHookData,
            connectorCache: params_.cacheData.connectorCache
        });
    }

    function adjustDecimals(
        uint256 amount,
        uint8 fromDecimals,
        uint8 toDecimals
    ) internal pure returns (uint256) {
        if (fromDecimals == toDecimals) {
            return amount;
        } else if (fromDecimals > toDecimals) {
            return amount / (10 ** (fromDecimals - toDecimals));
        } else {
            return amount * (10 ** (toDecimals - fromDecimals));
        }
    }

    function setTokenDecimals(
        address token,
        uint8[2] calldata decimals
    ) external onlyRole(RESCUE_ROLE) {
        tokenDecimals[token] = decimals;
        emit TokenDecimalsUpdated(token, decimals);
    }
}
