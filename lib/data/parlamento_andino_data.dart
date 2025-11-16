import '../models/parlamento_andino.dart';

class ParlamentoAndinoData {
  static List<ParlamentoAndino> getCandidatos() {
    return [
      // FUERZA POPULAR
      ParlamentoAndino(
        id: 'fp_pa1',
        nombre: 'Ignacio Torres Aguirre',
        partido: 'Fuerza Popular',
        consignas: ['Integración vial andina', 'Facilitar exportaciones entre países'],
      ),
      ParlamentoAndino(
        id: 'fp_pa2',
        nombre: 'Sandra Córdova Ramos',
        partido: 'Fuerza Popular',
        consignas: ['Coordinación policial transnacional', 'Seguridad fronteriza'],
      ),
      ParlamentoAndino(
        id: 'fp_pa3',
        nombre: 'Gerardo Luna Paredes',
        partido: 'Fuerza Popular',
        consignas: ['Innovación empresarial andina', 'Apoyo a PYMES exportadoras'],
      ),

      // ACCIÓN POPULAR
      ParlamentoAndino(
        id: 'ap_pa1',
        nombre: 'Daniela Rivera Cornejo',
        partido: 'Acción Popular',
        consignas: ['Educación intercultural andina', 'Intercambio académico regional'],
      ),
      ParlamentoAndino(
        id: 'ap_pa2',
        nombre: 'Hugo Márquez Torres',
        partido: 'Acción Popular',
        consignas: ['Facilitar comercio regional', 'Desarrollo de corredores logísticos'],
      ),
      ParlamentoAndino(
        id: 'ap_pa3',
        nombre: 'Lourdes Quito Valdez',
        partido: 'Acción Popular',
        consignas: ['Patrimonio cultural andino', 'Turismo sostenible regional'],
      ),

      // PARTIDO MORADO
      ParlamentoAndino(
        id: 'pm_pa1',
        nombre: 'Carolina Sandoval Núñez',
        partido: 'Partido Morado',
        consignas: ['Cooperación ambiental andina', 'Reducción de emisiones regionales'],
      ),
      ParlamentoAndino(
        id: 'pm_pa2',
        nombre: 'Juan Diego Montoya',
        partido: 'Partido Morado',
        consignas: ['Tecnología y desarrollo', 'Interoperabilidad digital'],
      ),
      ParlamentoAndino(
        id: 'pm_pa3',
        nombre: 'Mónica Fernández Araujo',
        partido: 'Partido Morado',
        consignas: ['Derechos ciudadanos andinos', 'Libre tránsito seguro'],
      ),

      // UNIÓN POR EL PERÚ
      ParlamentoAndino(
        id: 'up_pa1',
        nombre: 'Marcos Cárdenas Lazo',
        partido: 'Unión por el Perú',
        consignas: ['Fortalecer integración política', 'Cooperación legislativa'],
      ),
      ParlamentoAndino(
        id: 'up_pa2',
        nombre: 'Julia Huamán Quispe',
        partido: 'Unión por el Perú',
        consignas: ['Protección de migrantes', 'Salud transfronteriza'],
      ),
      ParlamentoAndino(
        id: 'up_pa3',
        nombre: 'Fernando Ruiz Delgado',
        partido: 'Unión por el Perú',
        consignas: ['Transporte regional', 'Inversión en infraestructura binacional'],
      ),

      // JUNTOS POR EL PERÚ
      ParlamentoAndino(
        id: 'jp_pa1',
        nombre: 'María Elena Berrocal',
        partido: 'Juntos por el Perú',
        consignas: ['Defensa del medio ambiente', 'Protección de pueblos originarios'],
      ),
      ParlamentoAndino(
        id: 'jp_pa2',
        nombre: 'César Pinedo Caballero',
        partido: 'Juntos por el Perú',
        consignas: ['Desarrollo rural andino', 'Cooperativas regionales'],
      ),
      ParlamentoAndino(
        id: 'jp_pa3',
        nombre: 'Elena Rojas Cabana',
        partido: 'Juntos por el Perú',
        consignas: ['Salud pública andina', 'Medicamentos accesibles'],
      ),

      // RENOVACIÓN POPULAR
      ParlamentoAndino(
        id: 'rp_pa1',
        nombre: 'José Manuel Alarcón',
        partido: 'Renovación Popular',
        consignas: ['Seguridad regional', 'Tratados contra el crimen organizado'],
      ),
      ParlamentoAndino(
        id: 'rp_pa2',
        nombre: 'Carla Montenegro Reátegui',
        partido: 'Renovación Popular',
        consignas: ['Valores familiares andinos', 'Integración cultural'],
      ),
      ParlamentoAndino(
        id: 'rp_pa3',
        nombre: 'Arturo Villanueva Ponce',
        partido: 'Renovación Popular',
        consignas: ['Estabilidad económica', 'Fortalecimiento de inversiones'],
      ),

      // ALIANZA PARA EL PROGRESO
      ParlamentoAndino(
        id: 'app_pa1',
        nombre: 'Lucía Huertas Mendoza',
        partido: 'Alianza para el Progreso',
        consignas: ['Educación universitaria común', 'Intercambio profesional'],
      ),
      ParlamentoAndino(
        id: 'app_pa2',
        nombre: 'Pedro Torrejón García',
        partido: 'Alianza para el Progreso',
        consignas: ['Innovación agrícola andina', 'Impulso a exportaciones'],
      ),
      ParlamentoAndino(
        id: 'app_pa3',
        nombre: 'Karla Ugarte Torres',
        partido: 'Alianza para el Progreso',
        consignas: ['Emprendimiento joven', 'Red andina de empleo'],
      ),

      // PERÚ LIBRE
      ParlamentoAndino(
        id: 'pl_pa1',
        nombre: 'Yolanda Camasca Apaza',
        partido: 'Perú Libre',
        consignas: ['Derechos laborales andinos', 'Cooperación sindical regional'],
      ),
      ParlamentoAndino(
        id: 'pl_pa2',
        nombre: 'Jorge Salas Yurivilca',
        partido: 'Perú Libre',
        consignas: ['Desarrollo comunitario', 'Soberanía alimentaria'],
      ),
      ParlamentoAndino(
        id: 'pl_pa3',
        nombre: 'Rosa Maita Condori',
        partido: 'Perú Libre',
        consignas: ['Protección ambiental', 'Agua para zonas altas'],
      ),

      // AVANZA PAÍS
      ParlamentoAndino(
        id: 'av_pa1',
        nombre: 'Alonso Vega Tudela',
        partido: 'Avanza País',
        consignas: ['Apertura comercial andina', 'Facilitar inversiones'],
      ),
      ParlamentoAndino(
        id: 'av_pa2',
        nombre: 'Nicole Araujo Castañeda',
        partido: 'Avanza País',
        consignas: ['Energías renovables regionales', 'Innovación eléctrica'],
      ),
      ParlamentoAndino(
        id: 'av_pa3',
        nombre: 'Harold Suárez Linares',
        partido: 'Avanza País',
        consignas: ['Modernización del transporte', 'Infraestructura común'],
      ),

      // PARTIDO SOCIALISTA
      ParlamentoAndino(
        id: 'ps_pa1',
        nombre: 'Diana Rentería Guzmán',
        partido: 'Partido Socialista',
        consignas: ['Derechos sociales regionales', 'Educación universal'],
      ),
      ParlamentoAndino(
        id: 'ps_pa2',
        nombre: 'Jhonatan Arce Cárdenas',
        partido: 'Partido Socialista',
        consignas: ['Salud gratuita andina', 'Integración sanitaria'],
      ),
      ParlamentoAndino(
        id: 'ps_pa3',
        nombre: 'Gerson Valdivia León',
        partido: 'Partido Socialista',
        consignas: ['Protección ambiental difusa', 'Equidad económica'],
      ),
    ];
  }
}
