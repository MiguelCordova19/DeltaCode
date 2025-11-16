import 'package:flutter/material.dart';
import 'candidatos_screen.dart';
import 'diputados_screen.dart';
import 'senadores_screen.dart';

class CandidatosMainScreen extends StatefulWidget {
  const CandidatosMainScreen({super.key});

  @override
  State<CandidatosMainScreen> createState() => _CandidatosMainScreenState();
}

class _CandidatosMainScreenState extends State<CandidatosMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Candidatos'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.how_to_vote),
              text: 'Presidenciales',
            ),
            Tab(
              icon: Icon(Icons.groups),
              text: 'Diputados',
            ),
            Tab(
              icon: Icon(Icons.account_balance),
              text: 'Senadores',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CandidatosScreen(),
          DiputadosScreen(),
          SenadoresScreen(),
        ],
      ),
    );
  }
}
