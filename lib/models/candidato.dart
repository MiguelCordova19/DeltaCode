class Candidato {
  final String nombre;
  final String cargo; // 'Representante Legal', 'Presidente', 'Vicepresidente 1', 'Vicepresidente 2'
  final String fotoPath;
  final String hojaVida;
  final String biografia;

  Candidato({
    required this.nombre,
    required this.cargo,
    required this.fotoPath,
    required this.hojaVida,
    required this.biografia,
  });

  // Datos de ejemplo con Lorem Ipsum
  static List<Candidato> getCandidatosPorPartido(String partidoId) {
    return [
      Candidato(
        nombre: 'Roberto Martínez Flores',
        cargo: 'Representante Legal',
        fotoPath: 'assets/images/candidatos/${partidoId}_representante.png',
        hojaVida: '''
• Abogado, Universidad Nacional Mayor de San Marcos
• Especialización en Derecho Electoral, Universidad de Salamanca
• Secretario General del Partido (2020-2024)
• Asesor Legal del Congreso (2015-2019)
• 18 años de experiencia en derecho político
        ''',
        biografia: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper.',
      ),
      Candidato(
        nombre: 'Juan Pérez García',
        cargo: 'Presidente',
        fotoPath: 'assets/images/candidatos/${partidoId}_presidente.png',
        hojaVida: '''
• Economista, Universidad Nacional Mayor de San Marcos
• Maestría en Políticas Públicas, Harvard University
• Ex Ministro de Economía (2018-2020)
• Congresista de la República (2016-2018)
• 25 años de experiencia en sector público
        ''',
        biografia: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
      ),
      Candidato(
        nombre: 'María López Sánchez',
        cargo: 'Vicepresidente 1',
        fotoPath: 'assets/images/candidatos/${partidoId}_vice1.png',
        hojaVida: '''
• Abogada, Pontificia Universidad Católica del Perú
• Especialización en Derechos Humanos, ONU
• Ex Ministra de la Mujer (2019-2021)
• Defensora del Pueblo (2015-2018)
• 20 años de experiencia en defensa de derechos
        ''',
        biografia: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.',
      ),
      Candidato(
        nombre: 'Carlos Rodríguez Torres',
        cargo: 'Vicepresidente 2',
        fotoPath: 'assets/images/candidatos/${partidoId}_vice2.png',
        hojaVida: '''
• Ingeniero Civil, Universidad Nacional de Ingeniería
• MBA, ESAN Graduate School of Business
• Ex Ministro de Transportes (2017-2019)
• Gerente General de Construcciones SAC
• 30 años de experiencia en infraestructura
        ''',
        biografia: 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi.',
      ),
    ];
  }
}
