import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class TerminosYCondicionesScreen extends StatelessWidget with ResponsiveMixin {
  const TerminosYCondicionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE500),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: setSp(24),
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Términos y Condiciones',
          style: TextStyle(
            color: Colors.black,
            fontSize: setSp(20),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: setWidth(24), vertical: setHeight(24)),
            child: ConstrainedBox(
              // Asegura que la tarjeta blanca ocupe al menos el alto de la pantalla
              // restando el padding vertical para que no genere scroll innecesario si la pantalla es gigante
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - setHeight(48)),
              child: Container(
                padding: EdgeInsets.all(setWidth(20)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Términos y Condiciones de Uso\n\"Ya Paso\"",
                      style: TextStyle(
                        fontSize: setSp(20),
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: setHeight(8)),
                    Text(
                      "Última actualización: Marzo 2026",
                      style: TextStyle(
                        fontSize: setSp(13),
                        color: const Color(0xFF999999),
                      ),
                    ),
                    SizedBox(height: setHeight(24)),
                    _buildSection(
                      title: "1. Aceptación de los Términos",
                      content:
                          "Al descargar, acceder y utilizar la aplicación \"Ya Paso\" (en adelante, \"la App\"), el usuario acepta estar sujeto a los presentes Términos y Condiciones. Si el usuario es menor de edad, declara contar con la autorización de sus padres o tutores legales para el uso de la App y la carga de saldo.",
                    ),
                    _buildSection(
                      title: "2. Descripción del Servicio",
                      content:
                          "La App es una plataforma tecnológica que permite a los alumnos, docentes y personal del establecimiento educativo realizar pedidos anticipados en el buffet escolar y gestionar un saldo virtual para abonar dichos pedidos, reduciendo los tiempos de espera.",
                    ),
                    _buildSection(
                      title: "3. Cuentas, Seguridad y Biometría",
                      content:
                          "• Responsabilidad: El usuario es el único responsable de mantener la confidencialidad de su contraseña.\n• Biometría: La App ofrece la opción de utilizar métodos biométricos (huella dactilar/FaceID) provistos por el dispositivo móvil. \"Ya Paso\" no almacena tus datos biométricos.\n• Baja de Cuenta: El usuario puede solicitar la eliminación de su cuenta en cualquier momento. Los datos personales serán anonimizados para cumplir con normativas fiscales.",
                    ),
                    _buildSection(
                      title: "4. Manejo de Saldos y Pagos",
                      content:
                          "• Naturaleza del Saldo: El saldo es de uso exclusivo dentro del buffet del establecimiento. La App no es una entidad financiera y el saldo no genera intereses.\n• Pasarela de Pagos: Las cargas de saldo digitales son procesadas por Mercado Pago. El usuario acepta también los términos de dicha pasarela.\n• Reembolsos: El saldo no utilizado no es canjeable por dinero en efectivo, salvo en casos de egreso definitivo del establecimiento.",
                    ),
                    _buildSection(
                      title: "5. Pedidos, Entregas y Cancelaciones",
                      content:
                          "• Compromiso de Compra: Al confirmar un pedido, el usuario asume el compromiso de retirarlo.\n• Pedidos No Retirados: Si un pedido marcado como \"Entregado/Listo\" no es retirado al finalizar su turno escolar, será descartado. No se realizarán reembolsos por pedidos olvidados.\n• Falta de Stock: Si el buffet no puede entregar un producto abonado, se reembolsará el importe exacto al saldo virtual.",
                    ),
                    _buildSection(
                      title: "6. Privacidad y Protección de Datos",
                      content:
                          "• Recopilación: La App recopila datos básicos con el fin de identificar al titular de los pedidos.\n• Uso: Los datos no serán vendidos ni cedidos a terceros ajenos al buffet.\n• Derechos: El usuario tiene derecho a acceder, rectificar y solicitar la supresión de sus datos personales (Ley 25.326).",
                    ),
                    _buildSection(
                      title: "7. Limitación de Responsabilidad",
                      content:
                          "La App actúa como un intermediario tecnológico. Cualquier reclamo relacionado con la calidad de los alimentos deberá dirigirse directamente a los responsables del buffet escolar.",
                    ),
                    _buildSection(
                      title: "8. Alergias y Dietas Especiales",
                      content:
                          "La App exhibe la información proporcionada exclusivamente por el buffet del establecimiento. \"Ya Paso\" no garantiza que los productos estén libres de alérgenos (TACC, maní, lactosa, etc.). Es responsabilidad indelegable del usuario o sus tutores consultar directamente con el personal del buffet sobre los ingredientes antes de efectuar el consumo.",
                    ),
                    _buildSection(
                      title: "9. Disponibilidad del Sistema",
                      content:
                          "La plataforma se ofrece \"tal cual\" y no se garantiza el acceso ininterrumpido a la misma. \"Ya Paso\" no se responsabiliza por demoras, pérdida de turnos o la imposibilidad de realizar pedidos derivadas de fallas en la conexión a internet o intermitencias en la pasarela de pagos.",
                    ),
                    _buildSection(
                      title: "10. Conducta del Usuario y Suspensión",
                      content:
                          "Nos reservamos el derecho de suspender, bloquear o dar de baja de forma unilateral y sin previo aviso a cualquier cuenta que realice un uso fraudulento de la plataforma, intente vulnerar la seguridad de la App, realice pedidos falsos recurrentes o mantenga conductas inapropiadas/ofensivas.",
                    ),
                    _buildSection(
                      title: "11. Propiedad Intelectual",
                      content:
                          "Todos los derechos sobre el diseño, código fuente, logotipos y contenido de la aplicación \"Ya Paso\" son de propiedad exclusiva de sus desarrolladores. Queda estrictamente prohibida su copia, reproducción, ingeniería inversa o uso comercial no autorizado por escrito.",
                    ),
                    _buildSection(
                      title: "12. Modificación de los Términos",
                      content:
                          "Nos reservamos el derecho a modificar estos Términos y Condiciones en cualquier momento para adaptarlos a novedades operativas o legales. Las modificaciones entrarán en vigencia al ser publicadas en la App. El uso continuado de la plataforma implica su plena aceptación.",
                    ),
                    _buildSection(
                      title: "13. Legislación y Jurisdicción",
                      content:
                          "Los presentes Términos y Condiciones se rigen por las leyes de la República Argentina. Ante cualquier controversia derivada del uso de la App, las partes se someten a la jurisdicción de los Tribunales Ordinarios competentes del Departamento Judicial de La Plata, renunciando expresamente a cualquier otro fuero que pudiera corresponder.",
                    ),
                    SizedBox(height: setHeight(20)),
                    Center(
                      child: Text(
                        "Al utilizar Ya Paso, estás aceptando estas condiciones.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: setSp(14),
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: setHeight(20)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.only(bottom: setHeight(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: setSp(16),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: setHeight(8)),
          Text(
            content,
            style: TextStyle(
              fontSize: setSp(14),
              color: const Color(0xFF666666),
              height: 1.5, // Interlineado para facilitar la lectura
            ),
          ),
        ],
      ),
    );
  }
}
