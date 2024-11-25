import 'package:flutter/material.dart';
import 'package:prueba_buffet/widgets/toggle_button.dart';

class MyBalance extends StatelessWidget {
  const MyBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mi Saldo',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const TarjetaYaPaso(),
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: SizedBox(
                height: 40,
                child: CustomToggleButton(
                    labels: const ["Mi Actividad", "Historial"],
                    initialSelectedIndex: 0,
                    onToggle: (index) {
                      return null;
                    }),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: TransactionsPage(),
            ))
          ],
        ),
      ),
    );
  }
}

class TarjetaYaPaso extends StatelessWidget {
  const TarjetaYaPaso({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 170,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFFfE500),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]),
        ),
        const Positioned(
          top: 10,
          left: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Billetera",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFE500)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Ya Paso",
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Lobster",
                          color: Color(0xFFFFE500))),
                  SizedBox(
                    width: 10,
                  ),
                  Text("4654",
                      style: TextStyle(fontSize: 20, color: Color(0xFF333333))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text("Saldo Disponible",
                  style: TextStyle(fontSize: 20, color: Color(0xFF333333))),
              SizedBox(
                height: 5,
              ),
              Text("\$0",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black))
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Image.asset(
            "assets/images/y_yapaso.png",
            width: 68,
          ),
        ),
        Positioned(
          bottom: -20,
          left: 15,
          child: SizedBox(
            width: 160,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.1),
                backgroundColor: const Color(0xFFFfE500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/icono_carga.png",
                    width: 30,
                  ),
                  const Text(
                    "Cargar",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          right: 15,
          child: SizedBox(
            width: 160,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.1),
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFFFfE500),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/icono_trans.png",
                    width: 30,
                  ),
                  const Text(
                    "Transferir",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TransactionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      "name": "Juan Garcia",
      "description": "Transferido con YaPaso",
      "amount": 900,
      "isIncome": true
    },
    {
      "name": "Franco Tarela",
      "description": "Transferido con YaPaso",
      "amount": 750,
      "isIncome": true
    },
    {
      "name": "Tomás Juarez",
      "description": "Transferiste con YaPaso",
      "amount": 500,
      "isIncome": false
    },
    {
      "name": "Agustina Moreira",
      "description": "Cargaste Saldo",
      "amount": 250,
      "isIncome": true
    },
    {
      "name": "Tomás Juarez",
      "description": "Transferiste con YaPaso",
      "amount": 100,
      "isIncome": false
    },
  ];

  TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${transaction["name"]}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${transaction["description"]}",
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "\$${transaction["amount"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    transaction["isIncome"]
                        ? Icons.north_east
                        : Icons.south_west,
                    color: transaction["isIncome"] ? Colors.green : Colors.red,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
