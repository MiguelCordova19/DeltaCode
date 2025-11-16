import '../models/diputado.dart';

class DiputadosData {
  static List<Diputado> getPrecandidatos() {
    return [
      // ACCIÓN POPULAR
      Diputado(nombre: 'Luis Alberto Cárdenas', partido: 'Acción Popular', consignas: ['Transparencia en la administración pública', 'Reforma educativa descentralizada', 'Fomento del turismo local'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'María Elena Vargas', partido: 'Acción Popular', consignas: ['Apoyo a los pequeños agricultores', 'Mejorar la infraestructura vial rural', 'Promover la cultura regional'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Juan Carlos Herrera', partido: 'Acción Popular', consignas: ['Fortalecer la descentralización política', 'Potenciar la salud primaria', 'Desarrollo sostenible para las provincias'], estado: EstadoCandidato.precandidato),
      
      // AHORA NACIÓN
      Diputado(nombre: 'Alfonso López Chau', partido: 'Ahora Nación', consignas: ['Innovación tecnológica para la educación', 'Desarrollo de infraestructura científica', 'Empoderamiento del talento joven'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Sofía Ramírez Torres', partido: 'Ahora Nación', consignas: ['Lucha contra la corrupción institucional', 'Transparencia en la contratación pública', 'Regulación ética del financiamiento político'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Víctor Manuel Quispe', partido: 'Ahora Nación', consignas: ['Fortalecimiento del federalismo regional', 'Mejorar la competitividad económica local', 'Promover la participación ciudadana'], estado: EstadoCandidato.precandidato),
      
      // ALIANZA PARA EL PROGRESO
      Diputado(nombre: 'César Acuña Peralta Jr.', partido: 'Alianza para el Progreso', consignas: ['Calidad educativa para todos', 'Emprendimiento en zonas vulnerables', 'Reducción de la informalidad laboral'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Natalia Guzmán Prado', partido: 'Alianza para el Progreso', consignas: ['Modernización de la agricultura', 'Acceso a crédito para agricultores pequeños', 'Incentivos para exportaciones locales'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Fernando López Vega', partido: 'Alianza para el Progreso', consignas: ['Turismo como motor de desarrollo', 'Mejorar la conectividad interregional', 'Protección del patrimonio cultural'], estado: EstadoCandidato.precandidato),
      
      // AVANZA PAÍS
      Diputado(nombre: 'Rosa María Delgado', partido: 'Avanza País – Partido de Integración Social', consignas: ['Salud pública universal', 'Mejoras en los hospitales públicos', 'Atención especial a zonas rurales'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Ricardo Torres Sifuentes', partido: 'Avanza País – Partido de Integración Social', consignas: ['Seguridad ciudadana y prevención del crimen', 'Cooperación internacional contra la delincuencia', 'Fortalecer la policía comunitaria'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Elena Vásquez Huamán', partido: 'Avanza País – Partido de Integración Social', consignas: ['Desarrollo social integral', 'Protección social para los más vulnerables', 'Programas de inclusión económica'], estado: EstadoCandidato.precandidato),
      
      // BATALLA PERÚ
      Diputado(nombre: 'Jorge Huamán Rojas', partido: 'Batalla Perú', consignas: ['Lucha fuerte contra la corrupción', 'Reforma política profunda', 'Educación con valores ciudadanos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Diana Paredes Quispe', partido: 'Batalla Perú', consignas: ['Protección de los derechos laborales', 'Trabajo digno para jóvenes', 'Impulso a la formalización laboral'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Mario Vega Sánchez', partido: 'Batalla Perú', consignas: ['Promover la justicia social', 'Apoyo a las comunidades más pobres', 'Políticas públicas para la reducción de la desigualdad'], estado: EstadoCandidato.precandidato),
      
      // FE EN EL PERÚ
      Diputado(nombre: 'Carlos Morales Castillo', partido: 'Fe en el Perú', consignas: ['Valores éticos en la política', 'Defensa de la familia', 'Educación moral en escuelas públicas'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Ana Lucía Pacheco', partido: 'Fe en el Perú', consignas: ['Protección de los más vulnerables', 'Programas para la infancia y la juventud', 'Compromiso con la paz social'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'José Manuel Álvarez', partido: 'Fe en el Perú', consignas: ['Unidad nacional basada en la fe', 'Participación ciudadana desde las comunidades', 'Diálogo interreligioso y social'], estado: EstadoCandidato.precandidato),
      
      // FRENTE POPULAR AGRÍCOLA FIA DEL PERÚ
      Diputado(nombre: 'Pedro Quispe Mamani', partido: 'Frente Popular Agrícola FIA del Perú', consignas: ['Agricultura sostenible', 'Apoyo a pequeños productores', 'Fortalecer el mercado agrario local'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Rosa Huanca Chura', partido: 'Frente Popular Agrícola FIA del Perú', consignas: ['Desarrollo rural con justicia social', 'Acceso a agua para comunidades agrícolas', 'Innovación para la agricultura andina'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'José Ángel Condori', partido: 'Frente Popular Agrícola FIA del Perú', consignas: ['Tecnología en agricultura', 'Capacitación para campesinos', 'Formación de cooperativas rurales'], estado: EstadoCandidato.precandidato),
      
      // FUERZA POPULAR
      Diputado(nombre: 'Keiko Fujimori Junior', partido: 'Fuerza Popular', consignas: ['Seguridad para las familias', 'Cero tolerancia a la delincuencia', 'Respeto al estado de derecho'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Rossángela Barbarán', partido: 'Fuerza Popular', consignas: ['Fiscalización y transparencia total', 'Políticas para la mujer emprendedora', 'Educación con disciplina y valores'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'César Revilla Ortega', partido: 'Fuerza Popular', consignas: ['Desarrollo empresarial nacional', 'Incentivos para inversiones', 'Mejorar el empleo formal'], estado: EstadoCandidato.precandidato),
      
      // JUNTOS POR EL PERÚ
      Diputado(nombre: 'Verónika Mendoza Ruiz', partido: 'Juntos por el Perú', consignas: ['Justicia social para todos', 'Educación gratuita de calidad', 'Protección del medio ambiente'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Marco Sánchez Huamán', partido: 'Juntos por el Perú', consignas: ['Derechos de los pueblos originarios', 'Descentralización real', 'Economía solidaria'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Lucía Torres Pizarro', partido: 'Juntos por el Perú', consignas: ['Salud pública universal', 'Medicina preventiva organizada', 'Atención comunitaria eficiente'], estado: EstadoCandidato.precandidato),

      // LIBERTAD POPULAR
      Diputado(nombre: 'Diego Castillo Paredes', partido: 'Libertad Popular', consignas: ['Liberalismo económico para todos', 'Reducción de impuestos a emprendedores', 'Fomento de la libre competencia'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'María Fernanda León', partido: 'Libertad Popular', consignas: ['Derechos individuales garantizados', 'Protección de las libertades civiles', 'Gobierno reducido y eficiente'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Javier Gómez Miranda', partido: 'Libertad Popular', consignas: ['Innovación tecnológica libre', 'Reducción del tamaño del Estado', 'Empoderar a las personas para crear riqueza'], estado: EstadoCandidato.precandidato),
      
      // NUEVO PERÚ POR EL BUEN VIVIR
      Diputado(nombre: 'Ciro Gálvez Pérez', partido: 'Nuevo Perú por el Buen Vivir', consignas: ['Respeto por la cultura ancestral', 'Economía inclusiva para las zonas rurales', 'Promover el turismo indígena'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Elena Quispe Ccasani', partido: 'Nuevo Perú por el Buen Vivir', consignas: ['Agricultura comunitaria', 'Sostenibilidad en la Amazonía', 'Educación bilingüe intercultural'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Mario Chacón Huerta', partido: 'Nuevo Perú por el Buen Vivir', consignas: ['Salud para las comunidades alejadas', 'Formación de líderes locales', 'Desarrollo integral para jóvenes rurales'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO APRISTA PERUANO
      Diputado(nombre: 'Alan García Jr.', partido: 'Partido Aprista Peruano', consignas: ['Solidaridad social con justicia', 'Impulso a la industrialización nacional', 'Educación para el progreso'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Lucía Fernández Alvarado', partido: 'Partido Aprista Peruano', consignas: ['Protección de los derechos laborales', 'Diálogo social con sindicatos', 'Políticas para el empleo estable'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Ricardo Prado Vásquez', partido: 'Partido Aprista Peruano', consignas: ['Paz social a través del desarrollo', 'Descentralización con participación ciudadana', 'Infraestructura para las regiones'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO CIUDADANOS POR EL PERÚ
      Diputado(nombre: 'Marco Rivera Castillo', partido: 'Partido Ciudadanos por el Perú', consignas: ['Participación ciudadana real', 'Fortalecer los espacios comunitarios', 'Transparencia desde abajo'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Paola Montenegro Durand', partido: 'Partido Ciudadanos por el Perú', consignas: ['Educación cívica en escuelas públicas', 'Promover el voluntariado social', 'Cooperación vecinal activa'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Fernando Salazar Quijada', partido: 'Partido Ciudadanos por el Perú', consignas: ['Gobierno abierto y responsable', 'Rendición de cuentas mensual', 'Tecnología para la participación ciudadana'], estado: EstadoCandidato.precandidato),

      // PARTIDO CÍVICO OBRAS
      Diputado(nombre: 'Luis Alberto Pérez Gómez', partido: 'Partido Cívico Obras', consignas: ['Infraestructura para el desarrollo', 'Mejorar carreteras en zonas rurales', 'Agua potable para todos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Sandra Ruiz Villanueva', partido: 'Partido Cívico Obras', consignas: ['Vivienda digna para familias de bajos recursos', 'Construcción de viviendas sociales', 'Proyectos de saneamiento básico'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Carlos Romero Huamán', partido: 'Partido Cívico Obras', consignas: ['Desarrollo urbano con planificación', 'Espacios verdes en ciudades', 'Movilidad sostenible'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO DE LOS TRABAJADORES Y EMPRENDEDORES
      Diputado(nombre: 'Miguel Ángel Torres', partido: 'Partido de los Trabajadores y Emprendedores – PTE Perú', consignas: ['Emprendimiento para jóvenes', 'Acceso a microcréditos', 'Capacitación técnica gratuita'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Rosa María Quispe', partido: 'Partido de los Trabajadores y Emprendedores – PTE Perú', consignas: ['Trabajo digno para todos', 'Protección de los derechos laborales', 'Sindicalización responsable'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Juan Pablo Mendoza', partido: 'Partido de los Trabajadores y Emprendedores – PTE Perú', consignas: ['Fomento de pequeñas empresas locales', 'Exportaciones desde provincias', 'Innovación para el crecimiento'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO DEL BUEN GOBIERNO
      Diputado(nombre: 'Elena Vargas Paredes', partido: 'Partido del Buen Gobierno', consignas: ['Gestión pública eficiente', 'Reducción de la burocracia', 'Presupuesto transparente'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Ricardo Díaz Salazar', partido: 'Partido del Buen Gobierno', consignas: ['Políticas de buen gobierno municipal', 'Capacitación de autoridades locales', 'Participación ciudadana activa'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'María Isabel Rojas', partido: 'Partido del Buen Gobierno', consignas: ['Ética pública en todos los niveles', 'Cero tolerancia a la corrupción', 'Rendición de cuentas permanente'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO DEMÓCRATA VERDE
      Diputado(nombre: 'Álex González Castillo Jr.', partido: 'Partido Demócrata Verde', consignas: ['Desarrollo sostenible para el Perú', 'Protección del medio ambiente', 'Energías limpias para el futuro'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Valeria Huamán Quispe', partido: 'Partido Demócrata Verde', consignas: ['Derechos de los pueblos originarios', 'Conservación de bosques', 'Políticas verdes para zonas rurales'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Fernando Pérez Sanz', partido: 'Partido Demócrata Verde', consignas: ['Movilidad urbana ecológica', 'Reciclaje y gestión de residuos', 'Educación ambiental desde jóvenes'], estado: EstadoCandidato.precandidato),

      // PARTIDO DEMOCRÁTICO FEDERAL
      Diputado(nombre: 'Virgilio Acuña Peralta Jr.', partido: 'Partido Democrático Federal', consignas: ['Federalismo para un Perú más justo', 'Descentralización administrativa', 'Mayor poder para las regiones'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'María Luisa Gamonal', partido: 'Partido Democrático Federal', consignas: ['Justicia social desde lo local', 'Gobiernos regionales fuertes', 'Desarrollo equitativo'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Carlos Eduardo Bravo', partido: 'Partido Democrático Federal', consignas: ['Participación ciudadana regional', 'Inversión en infraestructura regional', 'Educación adaptada a cada zona'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO DEMOCRÁTICO SOMOS PERÚ
      Diputado(nombre: 'Daniela Quispe Vásquez', partido: 'Partido Democrático Somos Perú', consignas: ['Protección social para todos', 'Salud y educación accesible', 'Trabajo decente para los peruanos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Julián Huamán Ríos', partido: 'Partido Democrático Somos Perú', consignas: ['Desarrollo con equidad', 'Inclusión de comunidades vulnerables', 'Fortalecer los derechos ciudadanos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Pamela Castillo Torres', partido: 'Partido Democrático Somos Perú', consignas: ['Infraestructura para la integración regional', 'Mejor transporte para zonas alejadas', 'Conectividad digital para todos'], estado: EstadoCandidato.precandidato),
      
      // FRENTE DE LA ESPERANZA 2021
      Diputado(nombre: 'María del Carmen Paredes', partido: 'Frente de la Esperanza 2021', consignas: ['Esperanza social para jóvenes', 'Oportunidades educativas y laborales', 'Participación de la juventud en política'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'José Ricardo Mendez', partido: 'Frente de la Esperanza 2021', consignas: ['Políticas de apoyo familiar', 'Protección a madres solteras', 'Programas de vivienda social'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Lucía Villanueva Flores', partido: 'Frente de la Esperanza 2021', consignas: ['Unidad comunitaria para el desarrollo', 'Proyectos vecinales sostenibles', 'Participación ciudadana real'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO MORADO
      Diputado(nombre: 'Julio Guzmán Sánchez', partido: 'Partido Morado', consignas: ['Innovación en la administración pública', 'Tecnología para la transparencia', 'Políticas progresistas para el cambio'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Carolina Villanueva García', partido: 'Partido Morado', consignas: ['Equidad de género en todos los niveles', 'Empoderamiento femenino', 'Políticas para la mujer emprendedora'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Ricardo Moreno Paredes', partido: 'Partido Morado', consignas: ['Educación moderna y accesible', 'Digitalización del sistema educativo', 'Formación de líderes del siglo XXI'], estado: EstadoCandidato.precandidato),

      // PARTIDO NACIONALISTA PERUANO
      Diputado(nombre: 'Ollanta Humala Jr.', partido: 'Partido Nacionalista Peruano', consignas: ['Nacionalismo con justicia social', 'Soberanía sobre recursos naturales', 'Desarrollo con identidad nacional'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Nadine Heredia Alarcón', partido: 'Partido Nacionalista Peruano', consignas: ['Programas sociales efectivos', 'Inclusión de comunidades andinas', 'Educación con valores nacionales'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Carlos Tubino Silva', partido: 'Partido Nacionalista Peruano', consignas: ['Defensa de la industria nacional', 'Protección del empleo peruano', 'Desarrollo económico soberano'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO PERÚ LIBRE
      Diputado(nombre: 'Vladimir Cerrón Rojas', partido: 'Partido Perú Libre', consignas: ['Transformación social profunda', 'Nacionalización de recursos estratégicos', 'Justicia para los más pobres'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Waldemar Cerrón Rojas', partido: 'Partido Perú Libre', consignas: ['Reforma agraria moderna', 'Apoyo a campesinos y comunidades', 'Desarrollo rural con equidad'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Flor Pablo Medina', partido: 'Partido Perú Libre', consignas: ['Educación pública de calidad', 'Salud universal gratuita', 'Derechos laborales garantizados'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO POLÍTICO NACIONAL PERÚ PATRIA SEGURA
      Diputado(nombre: 'Daniel Urresti Elera', partido: 'Partido Político Nacional Perú Patria Segura', consignas: ['Seguridad ciudadana efectiva', 'Mano dura contra la delincuencia', 'Protección de las familias peruanas'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Rosa Bartra Barriga', partido: 'Partido Político Nacional Perú Patria Segura', consignas: ['Orden y disciplina social', 'Fortalecer las fuerzas del orden', 'Justicia rápida y efectiva'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Miguel Torres Morales', partido: 'Partido Político Nacional Perú Patria Segura', consignas: ['Prevención del crimen organizado', 'Cooperación internacional en seguridad', 'Tecnología para combatir el delito'], estado: EstadoCandidato.precandidato),
      
      // PARTIDO POPULAR CRISTIANO
      Diputado(nombre: 'Lourdes Flores Nano', partido: 'Partido Popular Cristiano – PPC', consignas: ['Valores cristianos en la política', 'Defensa de la familia tradicional', 'Educación con principios morales'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Alberto Beingolea Delgado', partido: 'Partido Popular Cristiano – PPC', consignas: ['Economía social de mercado', 'Desarrollo con responsabilidad social', 'Protección de los más vulnerables'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Raúl Castro Stagnaro', partido: 'Partido Popular Cristiano – PPC', consignas: ['Democracia con valores', 'Participación ciudadana responsable', 'Justicia social cristiana'], estado: EstadoCandidato.precandidato),
      
      // PERÚ NACIÓN
      Diputado(nombre: 'Humberto Lay Sun', partido: 'Perú Nación', consignas: ['Desarrollo nacional integral', 'Industrialización del país', 'Empleo digno para todos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Patricia Juárez Gallegos', partido: 'Perú Nación', consignas: ['Fortalecimiento institucional', 'Lucha contra la corrupción', 'Transparencia en la gestión pública'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Jorge del Castillo Gálvez', partido: 'Perú Nación', consignas: ['Unidad nacional para el progreso', 'Diálogo político constructivo', 'Desarrollo con inclusión social'], estado: EstadoCandidato.precandidato),

      // PODEMOS PERÚ
      Diputado(nombre: 'José Luna Gálvez', partido: 'Podemos Perú', consignas: ['Educación técnica para jóvenes', 'Emprendimiento y desarrollo empresarial', 'Oportunidades para todos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'María del Carmen Alva', partido: 'Podemos Perú', consignas: ['Fortalecimiento del Congreso', 'Fiscalización efectiva del gobierno', 'Representación ciudadana real'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Enrique Wong Pujada', partido: 'Podemos Perú', consignas: ['Desarrollo económico sostenible', 'Inversión en infraestructura', 'Modernización del Estado'], estado: EstadoCandidato.precandidato),
      
      // PROGRESANDO PERÚ
      Diputado(nombre: 'Martín Vizcarra Cornejo', partido: 'Progresando Perú', consignas: ['Lucha frontal contra la corrupción', 'Reforma del sistema de justicia', 'Transparencia total en el gobierno'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Karina Beteta Rubín', partido: 'Progresando Perú', consignas: ['Desarrollo regional descentralizado', 'Infraestructura para las provincias', 'Conectividad para todo el país'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Luis Galarreta Velarde', partido: 'Progresando Perú', consignas: ['Modernización legislativa', 'Eficiencia en el Congreso', 'Leyes para el desarrollo nacional'], estado: EstadoCandidato.precandidato),
      
      // RENOVACIÓN POPULAR
      Diputado(nombre: 'Rafael López Aliaga', partido: 'Renovación Popular', consignas: ['Libertad económica para todos', 'Reducción del Estado', 'Emprendimiento sin trabas'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Norma Yarrow Lumbreras', partido: 'Renovación Popular', consignas: ['Seguridad ciudadana prioritaria', 'Defensa de la propiedad privada', 'Orden y progreso'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Jorge Montoya Manrique', partido: 'Renovación Popular', consignas: ['Valores conservadores', 'Defensa de la familia', 'Disciplina social'], estado: EstadoCandidato.precandidato),
      
      // RESTAURACIÓN NACIONAL
      Diputado(nombre: 'Hernando de Soto Polar', partido: 'Restauración Nacional', consignas: ['Formalización de la propiedad', 'Capitalismo popular', 'Derechos de propiedad para todos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Chiara Payet de Soto', partido: 'Restauración Nacional', consignas: ['Emprendimiento femenino', 'Acceso al crédito formal', 'Desarrollo económico inclusivo'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Álvaro Gutiérrez Cueva', partido: 'Restauración Nacional', consignas: ['Reforma del sistema legal', 'Simplificación burocrática', 'Economía de mercado libre'], estado: EstadoCandidato.precandidato),
      
      // SOLIDARIDAD NACIONAL
      Diputado(nombre: 'Luis Castañeda Lossio', partido: 'Solidaridad Nacional', consignas: ['Obras públicas para el desarrollo', 'Infraestructura urbana moderna', 'Servicios públicos eficientes'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Susana Villarán de la Puente', partido: 'Solidaridad Nacional', consignas: ['Gestión municipal eficiente', 'Participación ciudadana activa', 'Desarrollo urbano sostenible'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Fernando Andrade Carmona', partido: 'Solidaridad Nacional', consignas: ['Transporte público moderno', 'Espacios públicos de calidad', 'Ciudad para las personas'], estado: EstadoCandidato.precandidato),

      // TODOS POR EL PERÚ
      Diputado(nombre: 'Martín Belaunde Moreyra', partido: 'Todos por el Perú', consignas: ['Unidad nacional para el progreso', 'Desarrollo económico con inclusión', 'Educación de calidad para todos'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Mercedes Aráoz Fernández', partido: 'Todos por el Perú', consignas: ['Políticas económicas responsables', 'Inversión en capital humano', 'Competitividad internacional'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Pedro Olaechea Álvarez-Calderón', partido: 'Todos por el Perú', consignas: ['Fortalecimiento institucional', 'Gobernabilidad democrática', 'Diálogo político constructivo'], estado: EstadoCandidato.precandidato),
      
      // UNIÓN POR EL PERÚ
      Diputado(nombre: 'Antauro Humala Tasso', partido: 'Unión por el Perú', consignas: ['Nacionalismo radical', 'Justicia social revolucionaria', 'Transformación profunda del Estado'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Isaac Humala Tasso', partido: 'Unión por el Perú', consignas: ['Defensa de los recursos naturales', 'Soberanía nacional absoluta', 'Desarrollo autónomo'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Ulises Humala Tasso', partido: 'Unión por el Perú', consignas: ['Reforma del sistema político', 'Poder para el pueblo', 'Justicia redistributiva'], estado: EstadoCandidato.precandidato),
      
      // VAMOS PERÚ
      Diputado(nombre: 'Fernando Olivera Vega', partido: 'Vamos Perú', consignas: ['Lucha contra la corrupción política', 'Transparencia en la gestión pública', 'Ética en el servicio público'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Cecilia Tait Villacorta', partido: 'Vamos Perú', consignas: ['Deporte como herramienta de desarrollo', 'Juventud saludable y activa', 'Valores a través del deporte'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Javier Diez Canseco Terry', partido: 'Vamos Perú', consignas: ['Justicia social progresista', 'Derechos humanos garantizados', 'Inclusión de minorías'], estado: EstadoCandidato.precandidato),
      
      // VICTORIA NACIONAL
      Diputado(nombre: 'George Forsyth Sommer', partido: 'Victoria Nacional', consignas: ['Renovación política generacional', 'Gestión moderna y eficiente', 'Transparencia y rendición de cuentas'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Gino Costa Santolalla', partido: 'Victoria Nacional', consignas: ['Seguridad ciudadana inteligente', 'Reforma policial integral', 'Prevención del delito'], estado: EstadoCandidato.precandidato),
      Diputado(nombre: 'Patricia Chirinos Venegas', partido: 'Victoria Nacional', consignas: ['Empoderamiento de la mujer', 'Igualdad de oportunidades', 'Desarrollo con equidad de género'], estado: EstadoCandidato.precandidato),
    ];
  }

  static List<Diputado> getCandidatosOficiales() {
    return [
      // Aquí se agregarán los candidatos oficiales una vez sean confirmados
    ];
  }
}
