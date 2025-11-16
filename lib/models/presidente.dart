class Presidente {
  final String nombre;
  final String partido;
  final String periodo;
  final int anioInicio;
  final int? anioFin;
  final String duracion;
  final bool esActual;
  final String? imagenUrl;
  final String? mandatoCompleto;
  final String? motivoSalida;
  final String? wikipediaUrl;

  Presidente({
    required this.nombre,
    required this.partido,
    required this.periodo,
    required this.anioInicio,
    this.anioFin,
    required this.duracion,
    this.esActual = false,
    this.imagenUrl,
    this.mandatoCompleto,
    this.motivoSalida,
    this.wikipediaUrl,
  });
}
