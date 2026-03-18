class ImageHelper {
  /// Recibe la URL original de Cloudinary y le inyecta las transformaciones
  static String getOptimizedUrl(String rawUrl,
      {int width = 300, int height = 300}) {
    // Si la URL es vacía o no es de Cloudinary, la devolvemos igual
    if (rawUrl.isEmpty || !rawUrl.contains('cloudinary.com')) {
      return rawUrl;
    }

    const uploadSegment = 'upload/';
    final index = rawUrl.indexOf(uploadSegment);

    if (index == -1) return rawUrl;

    // Punto exacto donde insertar las transformaciones
    final insertPosition = index + uploadSegment.length;

    // Las transformaciones mágicas
    final transformations = 'c_fill,w_$width,h_$height,g_auto,q_auto,f_auto/';

    return rawUrl.substring(0, insertPosition) +
        transformations +
        rawUrl.substring(insertPosition);
  }
}
