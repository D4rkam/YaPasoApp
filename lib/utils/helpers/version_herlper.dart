bool isUpdateAvailable(String currentVersion, String latestVersion) {
  try {
    // Convertimos "2.1.0" en [2, 1, 0]
    List<int> current =
        currentVersion.split('+')[0].split('.').map(int.parse).toList();
    List<int> latest =
        latestVersion.split('+')[0].split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (latest[i] > current[i]) return true; // Hay actualización
      if (latest[i] < current[i])
        return false; // Estamos en una versión superior (beta)
    }
    return false; // Son exactamente iguales
  } catch (e) {
    return false; // Si falla el parseo, ante la duda, no molestamos al usuario
  }
}
