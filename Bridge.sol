// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

pragma solidity ^0.6.0;
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


pragma solidity ^0.6.2;
library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {codehash := extcodehash(account)}
        return (codehash != accountHash && codehash != 0x0);
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success,) = recipient.call{value : amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }
    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

pragma solidity ^0.6.0;
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

pragma solidity ^0.6.0;
contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


pragma solidity ^0.6.0;
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {// Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


pragma solidity ^0.6.0;

contract Bridge is Ownable {

    using SafeERC20 for IERC20;
    // struct Order {
    //     uint256 id; //timestamp+fromChainId+toChainId+counter
    //     uint256 toChainId; // enum 0-okexchaind, 1-heco,
    //     address tokenAddress;
    //     uint256 amount;
    //     address addressTo;
    //     address userAddress;
    // }

    struct TokenInfo {
        address token;
        uint256 fixFee;
        uint256 transMinLimit;
        uint256 transMaxLimit;
    }

    mapping(address => bool) public supportedTokens;
    bool public paused = false;
    uint256 public chainId;
    mapping(address => TokenInfo) public tokenInfo;
    mapping(uint256 => mapping(uint256 => bool)) public transferOutOrderIds; // chainId => OrderId
    address public transferOperator;
    address public withdrawOperator;
    uint256 public feeRate = 2;

    uint256 public oid = 0;

    event TransferIn(uint256 indexed id, address token, uint256 amount, uint256 fee, uint256 toChainId, address addressTo);
    event TransferOut(uint256 id, uint256 fromChainId, address token, uint256 amount, address addressTo);
    event Withdraw(address token, uint256 amount);

    constructor(uint256 _chainId, address _transferOperator, address _withdrawOperator, uint256 startOid, address firstToken,
        uint256 firstTokenFixFee, uint256 firstTokenTransMinLimit, uint256 firstTokenTransMaxLimit) public {
        chainId = _chainId;
        transferOperator = _transferOperator;
        withdrawOperator = _withdrawOperator;
        oid = startOid;
        TokenInfo storage t = tokenInfo[firstToken];
        t.token = firstToken;
        t.fixFee = firstTokenFixFee;
        t.transMinLimit = firstTokenTransMinLimit;
        t.transMaxLimit = firstTokenTransMaxLimit;
        supportedTokens[firstToken] = true;
    }

    function setFeeRate(uint256 _feeRate) public onlyOwner {
        feeRate = _feeRate;
    }
    function setTransferOperator(address _transferOperator) public onlyOwner {
        transferOperator = _transferOperator;
    }
    function setWithdrawOperator(address _withdrawOperator) public onlyOwner {
        withdrawOperator = _withdrawOperator;
    }
    function setPaused(bool _paused) public onlyOwner {
        paused = _paused;
    }
    function addSupportedToken(address _token, uint256 _fixFee, uint256 _transMinLimit, uint256 _transMaxLimit) public onlyOwner {
        supportedTokens[_token] = true;
        TokenInfo storage t = tokenInfo[_token];
        t.token = _token;
        t.fixFee = _fixFee;
        t.transMinLimit = _transMinLimit;
        t.transMaxLimit = _transMaxLimit;
    }
    function removeSupportedToken(address _token) public onlyOwner {
        supportedTokens[_token] = false;
    }



    function transferIn(address _token, uint256 _amount, uint256 _chainId, address _addressTo)  public returns (uint256) {
        require(!paused, "Bridge is stopped");
        require(_addressTo==msg.sender, "addressTo should be same with msgSender");
        require(supportedTokens[_token], "token not supported");
        require(tokenInfo[_token].transMinLimit <= _amount, "Trans amount is too small");
        require(tokenInfo[_token].transMaxLimit > _amount, "Trans amount is too big");

        uint256 orderId= oid;
        oid = oid + 1;
        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
        uint256 fee = _amount*feeRate/1000;
        if (fee < tokenInfo[_token].fixFee) {
            fee = tokenInfo[_token].fixFee;
        }
        emit TransferIn(orderId, _token, _amount, fee, _chainId, _addressTo);
        return orderId;
    }

    function existOrder(uint256 fromChainId, uint256 orderId) public view returns(bool) {
        return transferOutOrderIds[fromChainId][orderId];
    }

    function transferOut(uint256 fromChainId, uint256 orderId, address token, uint256 amount, address addressTo) public {
        require(msg.sender == transferOperator, "Not transferOperator!");
        require(!transferOutOrderIds[fromChainId][orderId], "Duplicate orderId!!");
        IERC20(token).safeTransfer(addressTo, amount);
        transferOutOrderIds[fromChainId][orderId] = true;
        emit TransferOut(orderId, fromChainId, token, amount, addressTo);
    }

    function withdraw(address token, uint256 amount) public {
        require(msg.sender == withdrawOperator, "Not withdrawOperator!");
        IERC20(token).safeTransfer(msg.sender, amount);
        emit Withdraw(token, amount);
    }

}
