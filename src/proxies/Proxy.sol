// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
import "@openzeppelin/contracts/utils/Address.sol";

abstract contract Proxy {
    /// @dev EIP-1967 compliant storage slot for the contract implementation address.

    event ProxyImplementationUpdated(
        address indexed previousImplementation,
        address indexed newImplementation
    );

    fallback() external payable {
        assembly {
            let implementationAddress := sload(
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            )
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(
                gas(),
                implementationAddress,
                0x0,
                calldatasize(),
                0,
                0
            )
            let retSz := returndatasize()
            returndatacopy(0, 0, retSz)
            switch success
            case 0 {
                revert(0, retSz)
            }
            default {
                return(0, retSz)
            }
        }
    }

    receive() external payable {}

    function _isContract(address target) private view returns (bool) {
        return target.code.length != 0;
    }

    function _setImplementation(
        address newImplementation,
        bytes memory data
    ) internal {
        require(
            _isContract(newImplementation),
            "Proxy: newImplementation is not a contract"
        );

        address previousImplementation;
        assembly {
            previousImplementation := sload(
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            )
        }

        assembly {
            sstore(
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc,
                newImplementation
            )
        }

        emit ProxyImplementationUpdated(
            previousImplementation,
            newImplementation
        );

        if (data.length > 0) {
            (bool success, ) = newImplementation.delegatecall(data);
            if (!success) {
                assembly {
                    let returnDataSize := returndatasize()
                    returndatacopy(0, 0, returnDataSize)
                    revert(0, returnDataSize)
                }
            }
        }
    }
}
