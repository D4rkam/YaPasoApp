import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/toggle_button.dart';

class MyBalance extends StatelessWidget with ResponsiveMixin {
  const MyBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: setSp(30),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Mi Saldo',
          style: TextStyle(fontSize: setSp(25), fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const TarjetaYaPaso(),
            Padding(
              padding: EdgeInsets.only(top: setHeight(55)),
              child: SizedBox(
                height: setHeight(40),
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
              padding: EdgeInsets.only(
                  top: setHeight(30), left: setWidth(30), right: setWidth(30)),
              child: TransactionsPage(),
            ))
          ],
        ),
      ),
    );
  }
}

class TarjetaYaPaso extends StatelessWidget with ResponsiveMixin {
  const TarjetaYaPaso({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: setWidth(
              375 * 0.9), // Original was MediaQuery * 0.9. Design width 375.
          height: setHeight(170),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFFfE500),
                width: setWidth(2),
              ),
              borderRadius: BorderRadius.circular(
                  setHeight(20)), // Using setHeight for radius usually safe
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: setWidth(3),
                  blurRadius: setWidth(7),
                  offset: Offset(0, setHeight(3)),
                )
              ]),
        ),
        Positioned(
          top: setHeight(10),
          left: setWidth(20),
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
                        fontSize: setSp(17),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFE500)),
                  ),
                  SizedBox(
                    width: setWidth(10),
                  ),
                  Text("Ya Paso",
                      style: TextStyle(
                          fontSize: setSp(17),
                          fontFamily: "Lobster",
                          color: const Color(0xFFFFE500))),
                  SizedBox(
                    width: setWidth(10),
                  ),
                  Text("4654",
                      style: TextStyle(
                          fontSize: setSp(20), color: const Color(0xFF333333))),
                ],
              ),
              SizedBox(
                height: setHeight(20),
              ),
              Text("Saldo Disponible",
                  style: TextStyle(
                      fontSize: setSp(20), color: const Color(0xFF333333))),
              SizedBox(
                height: setHeight(5),
              ),
              Text("\$0",
                  style: TextStyle(
                      fontSize: setSp(30),
                      fontWeight: FontWeight.w500,
                      color: Colors.black))
            ],
          ),
        ),
        Positioned(
          top: setHeight(10),
          right: setWidth(10),
          child: Image.asset(
            "assets/images/y_yapaso.png",
            width: setWidth(68),
          ),
        ),
        Positioned(
          bottom: setHeight(-20),
          left: setWidth(15),
          child: SizedBox(
            width: setWidth(160),
            height: setHeight(40),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.1),
                backgroundColor: const Color(0xFFFfE500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(setHeight(20)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/icono_carga.png",
                    width: setWidth(30),
                  ),
                  Text(
                    "Cargar",
                    style: TextStyle(
                        fontSize: setSp(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: setHeight(-20),
          right: setWidth(15),
          child: SizedBox(
            width: setWidth(160),
            height: setHeight(40),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.1),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: const Color(0xFFFfE500),
                  width: setWidth(2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(setHeight(20)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/icono_trans.png",
                    width: setWidth(30),
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

class TransactionsPage extends StatelessWidget with ResponsiveMixin {
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
          padding: EdgeInsets.only(bottom: setHeight(10)), // setHeight(10)
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${transaction["name"]}",
                    style: TextStyle(
                      fontSize: setSp(20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${transaction["description"]}",
                    style: TextStyle(
                      color: const Color(0xFF6A6A6A),
                      fontSize: setSp(17),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "\$${transaction["amount"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: setSp(22),
                    ),
                  ),
                  SizedBox(width: setWidth(10)),
                  Icon(
                    transaction["isIncome"]
                        ? Icons.north_east
                        : Icons.south_west,
                    color: transaction["isIncome"] ? Colors.green : Colors.red,
                    size: setSp(24), // default aprox 24
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
