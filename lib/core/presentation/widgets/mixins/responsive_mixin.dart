import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Mixin para proporcionar métodos de dimensionamiento responsivo.
///
/// Este mixin facilita el uso de `flutter_screenutil` para adaptar
/// el tamaño de los widgets y las fuentes a diferentes densidades de pantalla.
mixin ResponsiveMixin {
  /// Adapta un valor de ancho basado en el ancho de la pantalla de diseño.
  ///
  /// Ejemplo: `setWidth(100)` devolverá un valor proporcionalmente
  /// escalado para el ancho del dispositivo actual.
  double setWidth(num width) => ScreenUtil().setWidth(width);

  /// Adapta un valor de altura basado en la altura de la pantalla de diseño.
  ///
  /// Ejemplo: `setHeight(100)` devolverá un valor proporcionalmente
  /// escalado para la altura del dispositivo actual.
  double setHeight(num height) => ScreenUtil().setHeight(height);

  /// Adapta el tamaño de la fuente.
  ///
  /// `setSp(16)` escalará el texto para que sea legible en diferentes
  /// tamaños de pantalla, teniendo en cuenta las preferencias del usuario.
  double setSp(num fontSize) => ScreenUtil().setSp(fontSize);
}
