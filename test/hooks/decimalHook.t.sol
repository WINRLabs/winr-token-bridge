// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../../contracts/hooks/DecimalHook.sol";

contract TestDecimalHook is Test {
    DecimalHook public decimalHook;
    address public owner;
    address public vaultOrController;
    address public bscToWinrUsdcConnector;
    address public bscToWinrUsdtConnector;
    address public winrToBscUsdcConnector;
    address public winrToBscUsdtConnector;
    bytes32 role = keccak256("RESCUE_ROLE");

    error NoPermit(bytes32 role);

    event TokenDecimalsUpdated(address indexed token, uint8[2] decimals);

    function setUp() public {
        owner = address(1);
        vaultOrController = address(2);
        bscToWinrUsdcConnector = address(3);
        bscToWinrUsdtConnector = address(4);
        winrToBscUsdcConnector = address(5);
        winrToBscUsdtConnector = address(6);

        vm.startPrank(owner);
        decimalHook = new DecimalHook(owner, vaultOrController);

        decimalHook.setTokenDecimals(bscToWinrUsdcConnector, [18, 6]);
        decimalHook.setTokenDecimals(bscToWinrUsdtConnector, [18, 6]);
        decimalHook.setTokenDecimals(winrToBscUsdcConnector, [6, 18]);
        decimalHook.setTokenDecimals(winrToBscUsdtConnector, [6, 18]);
        vm.stopPrank();
    }

    function testSetTokenDecimals() public {
        uint8[2] memory decimals = [18, 6];

        vm.expectEmit(true, true, false, true);
        emit TokenDecimalsUpdated(bscToWinrUsdcConnector, decimals);

        vm.startPrank(owner);
        decimalHook.setTokenDecimals(bscToWinrUsdcConnector, decimals);

        uint8[2] memory ss = decimalHook.getTokenDecimals(
            bscToWinrUsdcConnector
        );
        assertEq(ss[0], 18, "First element should be 18");
        assertEq(ss[1], 6, "Second element should be 6");
    }

    function testSetTokenDecimalsNotOwner() public {
        uint8[2] memory decimals = [18, 6];

        vm.expectRevert(abi.encodeWithSelector(NoPermit.selector, role));
        vm.prank(address(7));
        decimalHook.setTokenDecimals(bscToWinrUsdcConnector, decimals);
    }

    function testSrcPreHookCall(uint256 amount) public {
        vm.assume(amount > 0 && amount < 1e36);

        address[4] memory connectors = [
            bscToWinrUsdcConnector,
            bscToWinrUsdtConnector,
            winrToBscUsdcConnector,
            winrToBscUsdtConnector
        ];

        for (uint i = 0; i < connectors.length; i++) {
            TransferInfo memory transferInfo = TransferInfo({
                receiver: address(8),
                amount: amount,
                extraData: ""
            });

            SrcPreHookCallParams memory params = SrcPreHookCallParams({
                connector: connectors[i],
                msgSender: address(this), // Use the test contract as the msgSender
                transferInfo: transferInfo
            });

            (
                TransferInfo memory result,
                bytes memory postHookData
            ) = decimalHook.srcPreHookCall(params);

            assertEq(result.receiver, transferInfo.receiver);
            assertEq(postHookData, "");

            uint8[2] memory decimals = decimalHook.getTokenDecimals(
                connectors[i]
            );
            uint256 expectedAmount = adjustDecimals(
                amount,
                decimals[0],
                decimals[1]
            );
            assertEq(result.amount, expectedAmount);
        }
    }

    function testDstPreHookCall(uint256 amount) public {
        vm.assume(amount > 0 && amount < 1e36);

        address[4] memory connectors = [
            bscToWinrUsdcConnector,
            bscToWinrUsdtConnector,
            winrToBscUsdcConnector,
            winrToBscUsdtConnector
        ];

        for (uint i = 0; i < connectors.length; i++) {
            TransferInfo memory transferInfo = TransferInfo({
                receiver: address(8),
                amount: amount,
                extraData: ""
            });

            DstPreHookCallParams memory params = DstPreHookCallParams({
                connector: connectors[i],
                connectorCache: "", // Use an empty bytes array for connectorCache
                transferInfo: transferInfo
            });

            (
                bytes memory postHookData,
                TransferInfo memory result
            ) = decimalHook.dstPreHookCall(params);

            assertEq(result.receiver, transferInfo.receiver);
            assertEq(postHookData, "");

            uint8[2] memory decimals = decimalHook.getTokenDecimals(
                connectors[i]
            );
            uint256 expectedAmount = adjustDecimals(
                amount,
                decimals[0],
                decimals[1]
            );
            assertEq(result.amount, expectedAmount);
        }
    }

    function testEdgeCaseDecimalAdjustments() public {
        // Test very large amount
        uint256 largeAmount = 2 ** 255 - 1; // Max uint256 value
        uint8[2] memory largeDecimals = [18, 6];

        // Test very small amount
        uint256 smallAmount = 1;
        uint8[2] memory smallDecimals = [6, 18];

        // Test extreme decimal difference
        uint8[2] memory extremeDecimals1 = [18, 1];
        uint8[2] memory extremeDecimals2 = [1, 18];

        // Perform tests here

        // Test very large amount
        vm.startPrank(owner);
        decimalHook.setTokenDecimals(address(100), largeDecimals);

        TransferInfo memory largeTransferInfo = TransferInfo({
            receiver: address(8),
            amount: largeAmount,
            extraData: ""
        });

        SrcPreHookCallParams memory largeParams = SrcPreHookCallParams({
            connector: address(100),
            msgSender: address(this),
            transferInfo: largeTransferInfo
        });

        (TransferInfo memory largeResult, ) = decimalHook.srcPreHookCall(
            largeParams
        );
        assertEq(
            largeResult.amount,
            largeAmount / 10 ** 12,
            "Large amount adjustment failed"
        );

        // Test very small amount
        decimalHook.setTokenDecimals(address(101), smallDecimals);

        TransferInfo memory smallTransferInfo = TransferInfo({
            receiver: address(8),
            amount: smallAmount,
            extraData: ""
        });

        SrcPreHookCallParams memory smallParams = SrcPreHookCallParams({
            connector: address(101),
            msgSender: address(this),
            transferInfo: smallTransferInfo
        });

        (TransferInfo memory smallResult, ) = decimalHook.srcPreHookCall(
            smallParams
        );
        assertEq(
            smallResult.amount,
            smallAmount * 10 ** 12,
            "Small amount adjustment failed"
        );

        // Test extreme decimal difference
        decimalHook.setTokenDecimals(address(102), extremeDecimals1);
        decimalHook.setTokenDecimals(address(103), extremeDecimals2);

        TransferInfo memory extremeTransferInfo = TransferInfo({
            receiver: address(8),
            amount: 1e18,
            extraData: ""
        });

        SrcPreHookCallParams memory extremeParams1 = SrcPreHookCallParams({
            connector: address(102),
            msgSender: address(this),
            transferInfo: extremeTransferInfo
        });

        SrcPreHookCallParams memory extremeParams2 = SrcPreHookCallParams({
            connector: address(103),
            msgSender: address(this),
            transferInfo: extremeTransferInfo
        });

        (TransferInfo memory extremeResult1, ) = decimalHook.srcPreHookCall(
            extremeParams1
        );
        (TransferInfo memory extremeResult2, ) = decimalHook.srcPreHookCall(
            extremeParams2
        );

        assertEq(
            extremeResult1.amount,
            1e1,
            "Extreme decimal adjustment (18 to 1) failed"
        );
        assertEq(
            extremeResult2.amount,
            1e35,
            "Extreme decimal adjustment (1 to 18) failed"
        );
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
}
