class Candidato {
  final String nombre;
  final String cargo; // 'Representante Legal', 'Presidente', 'Vicepresidente 1', 'Vicepresidente 2', etc.
  final String fotoPath;
  final String hojaVida;
  final String biografia;
  final int? orden; // Para ordenar múltiples candidatos del mismo cargo

  Candidato({
    required this.nombre,
    required this.cargo,
    required this.fotoPath,
    required this.hojaVida,
    required this.biografia,
    this.orden,
  });

  // Helper para generar el nombre del archivo de foto
  static String getFotoPath(String partidoId, String cargo, {int? numero}) {
    String cargoKey;
    switch (cargo.toLowerCase()) {
      case 'representante legal':
        cargoKey = 'representante';
        break;
      case 'presidente':
        cargoKey = 'presidente';
        break;
      case 'vicepresidente 1':
      case 'primer vicepresidente':
        cargoKey = 'vice1';
        break;
      case 'vicepresidente 2':
      case 'segundo vicepresidente':
        cargoKey = 'vice2';
        break;
      case 'vicepresidente 3':
      case 'tercer vicepresidente':
        cargoKey = 'vice3';
        break;
      default:
        cargoKey = cargo.toLowerCase().replaceAll(' ', '_');
    }
    
    // Si hay número mayor a 1, agregarlo con guión bajo
    if (numero != null && numero > 1) {
      return 'assets/images/candidatos/${partidoId}_${cargoKey}_$numero.png';
    }
    
    return 'assets/images/candidatos/${partidoId}_$cargoKey.png';
  }

  // Datos de candidatos por partido
  // Este método genera automáticamente candidatos basándose en los cargos estándar
  // Solo necesitas agregar las fotos con el nombre correcto
  static List<Candidato> getCandidatosPorPartido(String partidoId) {
    List<Candidato> candidatos = [];
    
    // Definir todos los cargos posibles a verificar
    final cargosConfig = [
      {
        'cargo': 'Representante Legal',
        'titulo': 'Representante Legal',
        'hojaVida': '• Abogado especializado en derecho electoral\n• Secretario General del Partido',
        'biografia': 'Representante legal del partido político.',
      },
      {
        'cargo': 'Presidente',
        'titulo': 'Candidato a Presidente',
        'hojaVida': '• Economista con maestría en políticas públicas\n• Ex Ministro de Economía',
        'biografia': 'Candidato a la presidencia de la república.',
      },
      {
        'cargo': 'Vicepresidente 1',
        'titulo': 'Primer Vicepresidente',
        'hojaVida': '• Profesional con experiencia en gestión pública',
        'biografia': 'Candidato a primer vicepresidente.',
      },
      {
        'cargo': 'Vicepresidente 2',
        'titulo': 'Segundo Vicepresidente',
        'hojaVida': '• Ingeniero con MBA\n• Ex Ministro de Transportes',
        'biografia': 'Candidato a segundo vicepresidente.',
      },
    ];
    
    // Para cada cargo, agregar el candidato base
    for (var config in cargosConfig) {
      candidatos.add(Candidato(
        nombre: config['titulo'] as String,
        cargo: config['cargo'] as String,
        fotoPath: getFotoPath(partidoId, config['cargo'] as String),
        hojaVida: config['hojaVida'] as String,
        biografia: config['biografia'] as String,
        orden: 1,
      ));
    }
    
    // Verificar si hay múltiples candidatos del mismo cargo (vice1_1, vice1_2, etc.)
    // Para Vicepresidente 1
    for (int i = 2; i <= 5; i++) {
      candidatos.add(Candidato(
        nombre: 'Primer Vicepresidente $i',
        cargo: 'Vicepresidente 1',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 1', numero: i),
        hojaVida: '• Profesional con experiencia en gestión pública',
        biografia: 'Candidato a primer vicepresidente.',
        orden: i,
      ));
    }
    
    // Para Vicepresidente 2
    for (int i = 2; i <= 5; i++) {
      candidatos.add(Candidato(
        nombre: 'Segundo Vicepresidente $i',
        cargo: 'Vicepresidente 2',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 2', numero: i),
        hojaVida: '• Ingeniero con MBA\n• Ex Ministro de Transportes',
        biografia: 'Candidato a segundo vicepresidente.',
        orden: i,
      ));
    }
    
    return candidatos;
  }

  // Ejemplo con múltiples candidatos del mismo cargo
  static List<Candidato> getCandidatosConMultiples(String partidoId) {
    return [
      // Representante Legal
      Candidato(
        nombre: 'Roberto Martínez Flores',
        cargo: 'Representante Legal',
        fotoPath: getFotoPath(partidoId, 'Representante Legal'),
        hojaVida: '• Abogado especializado en derecho electoral',
        biografia: 'Representante legal del partido.',
        orden: 1,
      ),
      
      // Presidente
      Candidato(
        nombre: 'Juan Pérez García',
        cargo: 'Presidente',
        fotoPath: getFotoPath(partidoId, 'Presidente'),
        hojaVida: '• Economista con maestría en políticas públicas',
        biografia: 'Candidato a la presidencia.',
        orden: 1,
      ),
      
      // Primer Vicepresidente
      Candidato(
        nombre: 'María López Sánchez',
        cargo: 'Vicepresidente 1',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 1'),
        hojaVida: '• Abogada especializada en derechos humanos',
        biografia: 'Primera vicepresidenta.',
        orden: 1,
      ),
      
      // Segundo Vicepresidente
      Candidato(
        nombre: 'Carlos Rodríguez Torres',
        cargo: 'Vicepresidente 2',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 2'),
        hojaVida: '• Ingeniero Civil con MBA',
        biografia: 'Segundo vicepresidente.',
        orden: 1,
      ),
      
      // Tercer Vicepresidente (ejemplo adicional)
      Candidato(
        nombre: 'Ana Fernández Ruiz',
        cargo: 'Vicepresidente 3',
        fotoPath: getFotoPath(partidoId, 'Vicepresidente 3'),
        hojaVida: '• Médica especialista en salud pública',
        biografia: 'Tercera vicepresidenta.',
        orden: 1,
      ),
    ];
  }

  // Agrupar candidatos por cargo
  static Map<String, List<Candidato>> agruparPorCargo(List<Candidato> candidatos) {
    final Map<String, List<Candidato>> grupos = {};
    
    for (var candidato in candidatos) {
      if (!grupos.containsKey(candidato.cargo)) {
        grupos[candidato.cargo] = [];
      }
      grupos[candidato.cargo]!.add(candidato);
    }
    
    // Ordenar cada grupo por el campo 'orden'
    grupos.forEach((cargo, lista) {
      lista.sort((a, b) => (a.orden ?? 0).compareTo(b.orden ?? 0));
    });
    
    return grupos;
  }
}
