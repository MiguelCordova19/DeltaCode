import 'package:flutter/material.dart';
import '../models/presidente_detalle.dart';

class PresidenteDetalleScreen extends StatelessWidget {
  final PresidenteDetalle detalle;
  final Color color;

  const PresidenteDetalleScreen({
    super.key,
    required this.detalle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar con gradiente
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                detalle.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.7)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        detalle.periodo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introducción
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: color, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Análisis del legado presidencial',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Puntos Positivos
                  _buildSeccion(
                    titulo: '✅ Puntos Positivos',
                    puntos: detalle.puntosPositivos,
                    colorFondo: Colors.green[50]!,
                    colorBorde: Colors.green[300]!,
                    colorIcono: Colors.green[700]!,
                  ),

                  const SizedBox(height: 24),

                  // Puntos Negativos
                  _buildSeccion(
                    titulo: '❌ Puntos Negativos',
                    puntos: detalle.puntosNegativos,
                    colorFondo: Colors.red[50]!,
                    colorBorde: Colors.red[300]!,
                    colorIcono: Colors.red[700]!,
                  ),

                  const SizedBox(height: 32),

                  // Nota final
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[300]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.amber[800], size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Esta información te ayuda a entender el contexto político y tomar decisiones informadas para las elecciones 2026.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber[900],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required List<String> puntos,
    required Color colorFondo,
    required Color colorBorde,
    required Color colorIcono,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorBorde, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorIcono.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorIcono,
              ),
            ),
          ),

          // Lista de puntos
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: puntos.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < puntos.length - 1 ? 16 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorIcono,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
