import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/evento_electoral.dart';

class CalendarioElectoralScreen extends StatefulWidget {
  const CalendarioElectoralScreen({super.key});

  @override
  State<CalendarioElectoralScreen> createState() =>
      _CalendarioElectoralScreenState();
}

class _CalendarioElectoralScreenState extends State<CalendarioElectoralScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<EventoElectoral> _todosEventos = EventosElectoralesData.getEventos();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<EventoElectoral> _getEventosDelDia(DateTime day) {
    return _todosEventos.where((evento) => evento.esEnFecha(day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Calendario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con tabs
          Container(
            color: const Color(0xFFE53935),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estás viendo: ${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime.now();
                            _selectedDay = DateTime.now();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Ir a Hoy'),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Todos'),
                    Tab(text: 'Elecciones'),
                    Tab(text: 'Miembros Mesa'),
                    Tab(text: 'Inscripciones'),
                  ],
                ),
              ],
            ),
          ),

          // Contenido
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCalendarioTab(null),
                  _buildCalendarioTab(TipoEvento.eleccion),
                  _buildCalendarioTab(TipoEvento.miembroMesa),
                  _buildCalendarioTab(TipoEvento.inscripcion),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarioTab(TipoEvento? filtroTipo) {
    final eventosFiltrados = filtroTipo == null
        ? _todosEventos
        : _todosEventos.where((e) => e.tipo == filtroTipo).toList();

    return Column(
      children: [
        // Calendario
        TableCalendar(
          locale: 'es_ES',
          firstDay: DateTime(2024, 7, 1),
          lastDay: DateTime(2026, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          eventLoader: (day) {
            return eventosFiltrados.where((e) => e.esEnFecha(day)).toList();
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: const Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: const Color(0xFFEF5350),
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: const Color(0xFFD32F2F),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE53935)),
          ),
        ),

        const Divider(),

        // Lista de eventos del día seleccionado
        Expanded(
          child: _buildEventosList(eventosFiltrados),
        ),
      ],
    );
  }

  Widget _buildEventosList(List<EventoElectoral> eventosFiltrados) {
    final eventosDelDia = _selectedDay != null
        ? eventosFiltrados.where((e) => e.esEnFecha(_selectedDay!)).toList()
        : [];

    if (eventosDelDia.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay eventos programados',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: eventosDelDia.length,
      itemBuilder: (context, index) {
        return _buildEventoCard(eventosDelDia[index]);
      },
    );
  }

  Widget _buildEventoCard(EventoElectoral evento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColorPorTipo(evento.tipo).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getColorPorTipo(evento.tipo).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getColorPorTipo(evento.tipo),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getTipoTexto(evento.tipo),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (evento.esFechaLimite) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'FECHA LÍMITE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            evento.titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (evento.descripcion != null) ...[
            const SizedBox(height: 4),
            Text(
              evento.descripcion!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
          if (evento.ubicacion != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  evento.ubicacion!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          if (!evento.yaPaso && evento.diasRestantes >= 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  evento.diasRestantes == 0
                      ? '¡Hoy!'
                      : 'Faltan ${evento.diasRestantes} días',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getColorPorTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.eleccion:
        return const Color(0xFFE53935); // Rojo principal
      case TipoEvento.miembroMesa:
        return const Color(0xFFD32F2F); // Rojo oscuro
      case TipoEvento.inscripcion:
        return const Color(0xFFEF5350); // Rojo claro
      case TipoEvento.debate:
        return const Color(0xFFE57373); // Rojo más claro
      case TipoEvento.propaganda:
        return const Color(0xFFB71C1C); // Rojo muy oscuro
      case TipoEvento.capacitacion:
        return const Color(0xFFC62828); // Rojo medio oscuro
      case TipoEvento.sorteo:
        return const Color(0xFFFF5252); // Rojo brillante
      default:
        return Colors.grey;
    }
  }

  String _getTipoTexto(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.eleccion:
        return 'ELECCIÓN';
      case TipoEvento.miembroMesa:
        return 'MIEMBRO MESA';
      case TipoEvento.inscripcion:
        return 'INSCRIPCIÓN';
      case TipoEvento.debate:
        return 'DEBATE';
      case TipoEvento.propaganda:
        return 'PROPAGANDA';
      case TipoEvento.capacitacion:
        return 'CAPACITACIÓN';
      case TipoEvento.sorteo:
        return 'SORTEO';
      default:
        return 'EVENTO';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }
}
