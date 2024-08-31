import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For the http package

class EthereumService {
  final String rpcUrl = 'https://your-rpc-url.com';
  final String privateKey = 'your-private-key';
  final String contractAddress = '0x55d398326f99059ff775485246999027b3197955';
  final String abi = [
    "function approve(address spender, uint256 amount) external returns (bool)",
    "function allowance(address owner, address spender) external view returns (uint256)",
    "function transferFrom(address from, address to, uint256 amount) external returns (bool)",
    "function balanceOf(address account) external view returns (uint256)",
    "function transfer(address to, uint256 amount) returns (bool)"
  ].toString(); // Your contract ABI

  late Web3Client _client;
  late DeployedContract _contract;
  late Credentials _credentials;

  EthereumService() {
    _client = Web3Client(rpcUrl, Client());
    // _credentials = EthPrivateKey.fromHex(privateKey);
    _contract = DeployedContract(
      ContractAbi.fromJson(abi, "ERC20"),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  // Future<EthereumAddress> getOwnAddress() async {
  //   return  _credentials.address;
  // }

  Future<dynamic> readContract(
      String functionName, List<dynamic> params) async {
    final function = _contract.function(functionName);
    final result = await _client.call(
      contract: _contract,
      function: function,
      params: params,
    );
    return result;
  }

  Future<String> writeContract(
      String functionName, List<dynamic> params) async {
    final function = _contract.function(functionName);
    final result = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: function,
        parameters: params,
      ),
      chainId: 11155111, 
    );
    return result;
  }
}
