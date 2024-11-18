import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/pay/pay_controller.dart';

class PayScreen extends StatefulWidget {
  final Future<String>? url;
  const PayScreen({super.key, this.url});

  @override
  State<PayScreen> createState() => _PayState();
}

class _PayState extends State<PayScreen> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  final PayController payController = Get.put(PayController());

  @override
  Widget build(BuildContext context) {
    final urlFuture = Get.arguments as Future<String>;
    final FutureBuilder<String?> futureBuilder = FutureBuilder<String>(
      future: urlFuture, // Get the URL from arguments
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final url = snapshot.data;
          if (url != null) {
            return app(url);
          } else {
            return const Center(
                child: Text("Error: Payment URL not available"));
          }
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
    return futureBuilder;
  }

  Scaffold app(String url) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pago"),
      ),
      body: SafeArea(
        child: Center(
            child: Stack(
          children: [
            InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(url)),
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  print(url);
                  if (url.toString().contains("https://yapaso.com/success")) {
                    webViewController?.goBack();
                    payController.goToSuccessPage();
                  } else if (url
                      .toString()
                      .contains("https://yapaso.com/failure")) {
                    webViewController?.goBack();
                    payController.goToFailurePage();
                  } else if (url
                      .toString()
                      .contains("https://yapaso.com/pending")) {
                    webViewController?.goBack();
                    payController.goToPendingPage();
                  }
                }),
          ],
        )),
      ),
    );
  }
}
