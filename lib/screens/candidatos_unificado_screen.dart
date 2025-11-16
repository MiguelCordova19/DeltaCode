import 'package:flutter/material.dart';
import '../models/partido_politico.dart';
import '../models/candidato.dart';
import '../models/diputado.dart';
import '../models/senador.dart';
import '../models/parlamento_andino.dart';
import '../data/diputados_data.dart';
import '../data/senadores_data.dart';
import '../data/parlamento_andino_data.dart';
import 'candidato_detalle_screen.dart';

enum TipoCandidatura {
  presidenciales,
  diputados,
  senadores,
  parlamentoAndino,
}

enum TipoSenadorFiltro {
  nacional,
  regional,
}

class CandidatosUnificadoScreen extends StatefulWidget {
  const CandidatosUnificadoScreen({super.key});

  @override
  State<CandidatosUnificadoScreen> createState() => _CandidatosUnificadoScreenState();
}

class _CandidatosUnificadoScreenState extends State<CandidatosUnificadoScreen> {
  TipoCandidatura _tipoCandidatura = TipoCandidatura.presidenciales;
  TipoSenadorFiltro _tipoSenadorFiltro = TipoSenadorFiltro.nacional;
  PartidoPolitico? _selectedPartido;
  final List<PartidoPolitico> _partidos = PartidoPolitico.getPartidos();
  final TextEditingController _searchController = TextEditingController();
  List<PartidoPolitico> _filteredPartidos = [];

  @override
  void initState() {
    super.initState();
    _filteredPartidos = _partidos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPartidos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPartidos = _partidos;
      } else {
        _filteredPartidos = _partidos.where((partido) {
          return partido.nombre.toLowerCase().contains(query.toLowerCase()) ||
                 partido.nombreCorto.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  String _getTipoCandidaturaLabel() {
    switch (_tipoCandidatura) {
      case TipoCandidatura.presidenciales:
        return 'Presidenciales';
      case TipoCandidatura.diputados:
        return 'Diputados';
      case TipoCandidatura.senadores:
        return 'Senadores';
      case TipoCandidatura.parlamentoAndino:
        return 'Parlamento Andino';
    }
  }

  IconData _getTipoCandidaturaIcon() {
    switch (_tipoCandidatura) {
      case TipoCandidatura.presidenciales:
        return Icons.how_to_vote;
      case TipoCandidatura.diputados:
        return Icons.groups;
      case TipoCandidatura.senadores:
        return Icons.account_balance;
      case TipoCandidatura.parlamentoAndino:
        return Icons.public;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedPartido == null ? _buildPartidosList() : _buildCandidatosList(),
    );
  }

  Widget _buildPartidosList() {
    return Column(
      children: [
        // Header rojo
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE53935),
                Color(0xFFEF5350),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Candidatos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Barra de búsqueda
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPartidos,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar partido político...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _filterPartidos('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),

        // Filtro de tipo de candidatura
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo de candidatura:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTipoChip(
                      'Presidenciales',
                      Icons.how_to_vote,
                      TipoCandidatura.presidenciales,
                    ),
                    const SizedBox(width: 8),
                    _buildTipoChip(
                      'Diputados',
                      Icons.groups,
                      TipoCandidatura.diputados,
                    ),
                    const SizedBox(width: 8),
                    _buildTipoChip(
                      'Senadores',
                      Icons.account_balance,
                      TipoCandidatura.senadores,
                    ),
                    const SizedBox(width: 8),
                    _buildTipoChip(
                      'Parlamento Andino',
                      Icons.public,
                      TipoCandidatura.parlamentoAndino,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sub-filtro para senadores (Nacional/Regional)
        if (_tipoCandidatura == TipoCandidatura.senadores)
          Container(
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildSubFiltroChip(
                    'Nacional',
                    Icons.public,
                    TipoSenadorFiltro.nacional,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSubFiltroChip(
                    'Regional',
                    Icons.map,
                    TipoSenadorFiltro.regional,
                  ),
                ),
              ],
            ),
          ),

        // Lista de partidos
        Expanded(
          child: _filteredPartidos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron partidos',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredPartidos.length,
                  itemBuilder: (context, index) {
                    return _buildPartidoCard(_filteredPartidos[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTipoChip(String label, IconData icon, TipoCandidatura tipo) {
    final isSelected = _tipoCandidatura == tipo;
    
    return InkWell(
      onTap: () {
        setState(() {
          _tipoCandidatura = tipo;
          _selectedPartido = null;
          if (tipo == TipoCandidatura.senadores) {
            _tipoSenadorFiltro = TipoSenadorFiltro.nacional;
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE53935) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubFiltroChip(String label, IconData icon, TipoSenadorFiltro tipo) {
    final isSelected = _tipoSenadorFiltro == tipo;
    
    return InkWell(
      onTap: () {
        setState(() {
          _tipoSenadorFiltro = tipo;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE53935) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartidoCard(PartidoPolitico partido) {
    return FutureBuilder<int>(
      future: _getNumCandidatos(partido),
      builder: (context, snapshot) {
        final numCandidatos = snapshot.data ?? 0;
        return _buildPartidoCardContent(partido, numCandidatos);
      },
    );
  }

  Future<int> _getNumCandidatos(PartidoPolitico partido) async {
    switch (_tipoCandidatura) {
      case TipoCandidatura.presidenciales:
        final candidatos = Candidato.getCandidatosPorPartido(partido.id);
        final validos = await _filterCandidatosConFotos(candidatos);
        return validos.length;
      case TipoCandidatura.diputados:
        final allDiputados = DiputadosData.getPrecandidatos();
        return allDiputados.where((d) => d.partido == partido.nombre).length;
      case TipoCandidatura.senadores:
        final allSenadores = _tipoSenadorFiltro == TipoSenadorFiltro.nacional
            ? SenadoresData.getPrecandidatosNacionales()
            : SenadoresData.getPrecandidatosRegionales();
        return allSenadores.where((s) => s.partido == partido.nombre).length;
      case TipoCandidatura.parlamentoAndino:
        final allParlamento = ParlamentoAndinoData.getCandidatos();
        return allParlamento.where((p) => p.partido == partido.nombre).length;
    }
  }

  Widget _buildPartidoCardContent(PartidoPolitico partido, int numCandidatos) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPartido = partido;
            });
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFFD32F2F).withOpacity(0.3),
          highlightColor: const Color(0xFFD32F2F).withOpacity(0.2),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD32F2F).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD32F2F).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Logo del partido
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: _buildPartidoImage(partido.logoPath),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Información del partido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partido.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD32F2F).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFD32F2F).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                partido.nombreCorto,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                            ),
                            if (numCandidatos > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE53935).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getTipoCandidaturaIcon(),
                                      size: 12,
                                      color: const Color(0xFFE53935),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$numCandidatos',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFE53935),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Flecha
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFD32F2F),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartidoImage(String logoPath) {
    return Image.asset(
      logoPath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCandidatosList() {
    return Column(
      children: [
        // Header con partido seleccionado
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935).withOpacity(0.05),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    setState(() {
                      _selectedPartido = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE53935),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildPartidoImage(_selectedPartido!.logoPath),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedPartido!.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getTipoCandidaturaIcon(),
                            size: 16,
                            color: const Color(0xFFE53935),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getTipoCandidaturaLabel(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lista de candidatos según el tipo
        Expanded(
          child: _buildCandidatosContent(),
        ),
      ],
    );
  }

  Widget _buildCandidatosContent() {
    switch (_tipoCandidatura) {
      case TipoCandidatura.presidenciales:
        return _buildPresidencialesList();
      case TipoCandidatura.diputados:
        return _buildDiputadosList();
      case TipoCandidatura.senadores:
        return _buildSenadoresList();
      case TipoCandidatura.parlamentoAndino:
        return _buildParlamentoAndinoList();
    }
  }

  Widget _buildPresidencialesList() {
    final candidatos = Candidato.getCandidatosPorPartido(_selectedPartido!.id);
    
    return FutureBuilder<List<Candidato>>(
      future: _filterCandidatosConFotos(candidatos),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                color: Color(0xFFE53935),
              ),
            ),
          );
        }
        
        final candidatosValidos = snapshot.data ?? [];
        
        if (candidatosValidos.isEmpty) {
          return _buildEmptyState('No hay candidatos presidenciales registrados');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: candidatosValidos.length,
          itemBuilder: (context, index) {
            final candidato = candidatosValidos[index];
            return _buildCandidatoPresidencialCard(candidato);
          },
        );
      },
    );
  }

  Future<List<Candidato>> _filterCandidatosConFotos(List<Candidato> candidatos) async {
    List<Candidato> validos = [];
    
    for (var candidato in candidatos) {
      try {
        await DefaultAssetBundle.of(context).load(candidato.fotoPath);
        validos.add(candidato);
      } catch (e) {
        // La imagen no existe, no agregar este candidato
      }
    }
    
    return validos;
  }

  Widget _buildDiputadosList() {
    final allDiputados = DiputadosData.getPrecandidatos();
    final diputados = allDiputados
        .where((d) => d.partido == _selectedPartido!.nombre)
        .toList();

    if (diputados.isEmpty) {
      return _buildEmptyState('No hay candidatos a diputados registrados');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diputados.length,
      itemBuilder: (context, index) {
        return _buildDiputadoCard(diputados[index]);
      },
    );
  }

  Widget _buildSenadoresList() {
    final allSenadores = _tipoSenadorFiltro == TipoSenadorFiltro.nacional
        ? SenadoresData.getPrecandidatosNacionales()
        : SenadoresData.getPrecandidatosRegionales();
    
    final senadores = allSenadores
        .where((s) => s.partido == _selectedPartido!.nombre)
        .toList();

    if (senadores.isEmpty) {
      return _buildEmptyState(
        _tipoSenadorFiltro == TipoSenadorFiltro.nacional
            ? 'No hay candidatos a senadores nacionales registrados'
            : 'No hay candidatos a senadores regionales registrados'
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: senadores.length,
      itemBuilder: (context, index) {
        return _buildSenadorCard(senadores[index]);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidatoPresidencialCard(Candidato candidato) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE53935).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CandidatoDetalleScreen(
                  candidato: candidato,
                  partido: _selectedPartido!,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      candidato.fotoPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 40);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidato.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        candidato.cargo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Ver detalles',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiputadoCard(Diputado diputado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE53935).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              diputado.nombre,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Consignas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE53935),
              ),
            ),
            const SizedBox(height: 8),
            ...diputado.consignas.map((consigna) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        consigna,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSenadorCard(Senador senador) {
    final isRegional = senador.tipo == TipoSenador.regional;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE53935).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del senador
            Text(
              senador.nombre,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Región o profesión/edad
            if (isRegional && senador.region != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  senador.region!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE53935),
                  ),
                ),
              )
            else if (senador.profesion != null && senador.edad != null)
              Text(
                '${senador.profesion} • ${senador.edad} años',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            if (senador.biografia != null) ...[
              const SizedBox(height: 12),
              Text(
                senador.biografia!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              'Propuestas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE53935),
              ),
            ),
            const SizedBox(height: 8),
            ...senador.propuestas.map((propuesta) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        propuesta,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildParlamentoAndinoList() {
    final allParlamento = ParlamentoAndinoData.getCandidatos();
    final candidatos = allParlamento
        .where((p) => p.partido == _selectedPartido!.nombre)
        .toList();

    if (candidatos.isEmpty) {
      return _buildEmptyState('No hay candidatos al Parlamento Andino registrados');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: candidatos.length,
      itemBuilder: (context, index) {
        return _buildParlamentoAndinoCard(candidatos[index]);
      },
    );
  }

  Widget _buildParlamentoAndinoCard(ParlamentoAndino candidato) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE53935).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del candidato
            Text(
              candidato.nombre,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Consignas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE53935),
              ),
            ),
            const SizedBox(height: 8),
            ...candidato.consignas.map((consigna) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        consigna,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
