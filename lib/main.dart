import 'package:crypto_1/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto_1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;
  double _value = 0;
  int myAmount = 0;

  final String myAddress = '0xF72458963aee782AADA98E5Ee3AC7188197f0E62';

  var myData;

  @override
  void initState() {
    super.initState();

    httpClient = Client();
    ethClient = Web3Client(
        'https://rinkeby.infura.io/v3/a2456250b9434cad9692ef9dc0783e38',
        httpClient);
    getBalance(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = '0x6E7DeB8D9896D82e93861b6730dE1e63cF41Bb1C';

    final contract = DeployedContract(ContractAbi.fromJson(abi, 'MyContract'),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query('getBalance', []);
    myData = result[0];
    data = true;
    setState(() {});
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials =
        EthPrivateKey.fromHex('36c2b151a0b8256b3acb8c803e078c2ff6d9098e00fb6780bc88623ef8d93217');

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);

    final result = await ethClient.sendTransaction(credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),fetchChainIdFromNetworkId: true,chainId: null);
  return result;
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit('depositBalance', [bigAmount]);

    return response;
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit('wirhdrowBalance', [bigAmount]);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              color: Colors.blue[300],
              height: MediaQuery.of(context).size.height / 3.33,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  'djordje coin',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height / 11),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 70,
            child: Card(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height / 3.9,
                width: MediaQuery.of(context).size.width / 1.05,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: MediaQuery.of(context).size.height / 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    data
                        ? Text(
                            '\$$myData',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 10,
                                fontWeight: FontWeight.bold),
                          )
                        : Center(child: CircularProgressIndicator()),
                    SizedBox(
                      height: 30,
                    ),
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 1.9,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SliderWidget(
                        value: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                            myAmount = (value * 100).round();
                          });
                        },
                        min: 0,
                        max: 100,
                      )
                      // TODO: make function in slider widget to set value of slider to value of variable in jour state
                      ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () => getBalance(myAddress),
                          child: Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text(
                                'Refresh',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                        ),
                        TextButton(
                          onPressed: () => sendCoin(),
                          child: Row(
                            children: [
                              Icon(
                                Icons.call_made_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                'Deposit',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () => withdrawCoin(),
                          child: Row(
                            children: [
                              Icon(
                                Icons.call_received_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                'Withdraw',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
