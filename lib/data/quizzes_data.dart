import '../models/quiz.dart';

class QuizzesData {
  static List<Quiz> obtenerQuizzes() {
    return [
      // Quiz: Valentín Paniagua
      Quiz(
        id: 'quiz_paniagua',
        titulo: 'Valentín Paniagua',
        descripcion: 'Gobierno de transición 2000-2001',
        presidenteRelacionado: 'Valentín Paniagua',
        preguntas: [
          Pregunta(
            pregunta: '¿Cuál fue el rol principal de Valentín Paniagua?',
            opciones: [
              'Presidente electo por voto popular',
              'Presidente de transición democrática',
              'Vicepresidente que asumió el cargo',
              'Presidente del Congreso',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Paniagua fue presidente de transición tras la caída de Fujimori, restaurando la democracia.',
          ),
          Pregunta(
            pregunta: '¿Cuánto duró aproximadamente el gobierno de Paniagua?',
            opciones: [
              '3 meses',
              '8 meses',
              '1 año',
              '2 años',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Su gobierno transitorio duró aproximadamente 8 meses, de noviembre 2000 a julio 2001.',
          ),
          Pregunta(
            pregunta: '¿Qué comisión importante promovió Paniagua?',
            opciones: [
              'Comisión Anticorrupción',
              'Comisión de la Verdad',
              'Comisión Electoral',
              'Comisión de Reforma',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Promovió la Comisión de la Verdad para investigar la violencia política en el Perú.',
          ),
          Pregunta(
            pregunta: '¿A qué partido político pertenecía Paniagua?',
            opciones: [
              'APRA',
              'Perú Posible',
              'Acción Popular',
              'Partido Morado',
            ],
            respuestaCorrecta: 2,
            explicacion: 'Valentín Paniagua era miembro de Acción Popular.',
          ),
          Pregunta(
            pregunta: '¿Qué logró principalmente su gobierno transitorio?',
            opciones: [
              'Reformas económicas profundas',
              'Restaurar instituciones democráticas',
              'Firmar tratados internacionales',
              'Reducir la pobreza significativamente',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Su principal logro fue restaurar las instituciones democráticas tras la crisis de Fujimori.',
          ),
        ],
      ),

      // Quiz: Alejandro Toledo
      Quiz(
        id: 'quiz_toledo',
        titulo: 'Alejandro Toledo',
        descripcion: 'Periodo 2001-2006',
        presidenteRelacionado: 'Alejandro Toledo',
        preguntas: [
          Pregunta(
            pregunta: '¿Qué caracterizó el gobierno de Alejandro Toledo?',
            opciones: [
              'Crisis económica severa',
              'Crecimiento económico sostenido',
              'Guerra con países vecinos',
              'Nacionalización de empresas',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Su gobierno se caracterizó por un crecimiento económico sostenido, parte del "milagro peruano".',
          ),
          Pregunta(
            pregunta: '¿A qué partido pertenecía Toledo?',
            opciones: [
              'Acción Popular',
              'APRA',
              'Perú Posible',
              'Fuerza Popular',
            ],
            respuestaCorrecta: 2,
            explicacion: 'Alejandro Toledo fundó y lideró el partido Perú Posible.',
          ),
          Pregunta(
            pregunta: '¿Qué índice mejoró durante su gobierno?',
            opciones: [
              'Índice de Corrupción',
              'Índice de Desarrollo Humano',
              'Índice de Inflación',
              'Índice de Desempleo',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'El Índice de Desarrollo Humano mejoró significativamente durante su periodo.',
          ),
          Pregunta(
            pregunta: '¿Qué tipo de acuerdos promovió Toledo?',
            opciones: [
              'Acuerdos militares',
              'Acuerdos comerciales internacionales',
              'Acuerdos de paz',
              'Acuerdos culturales',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Promovió la apertura internacional firmando acuerdos comerciales y atrayendo inversión extranjera.',
          ),
          Pregunta(
            pregunta: '¿Cuál fue una crítica principal a su gobierno?',
            opciones: [
              'Falta de crecimiento económico',
              'Desigualdad persistente',
              'Aumento de la inflación',
              'Reducción de exportaciones',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'A pesar del crecimiento económico, la desigualdad persistió y no todos se beneficiaron por igual.',
          ),
        ],
      ),

      // Quiz: Alan García
      Quiz(
        id: 'quiz_garcia',
        titulo: 'Alan García',
        descripcion: 'Segundo gobierno 2006-2011',
        presidenteRelacionado: 'Alan García Pérez',
        preguntas: [
          Pregunta(
            pregunta: '¿Qué fenómeno económico benefició el gobierno de García?',
            opciones: [
              'Crisis financiera mundial',
              'Boom de materias primas',
              'Devaluación del dólar',
              'Aumento del turismo',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Su gobierno coincidió con el boom de materias primas, generando crecimiento económico.',
          ),
          Pregunta(
            pregunta: '¿Cuánto se redujo aproximadamente la pobreza en su gobierno?',
            opciones: [
              'De 48.7% a 30%',
              'De 60% a 50%',
              'De 30% a 20%',
              'De 70% a 60%',
            ],
            respuestaCorrecta: 0,
            explicacion:
                'La pobreza se redujo significativamente de aproximadamente 48.7% en 2005 a cerca de 30% en 2010.',
          ),
          Pregunta(
            pregunta: '¿A qué partido pertenecía Alan García?',
            opciones: [
              'Acción Popular',
              'Perú Posible',
              'APRA (Partido Aprista Peruano)',
              'Fuerza Popular',
            ],
            respuestaCorrecta: 2,
            explicacion: 'Alan García era líder del APRA (Partido Aprista Peruano).',
          ),
          Pregunta(
            pregunta: '¿Qué tipo de conflictos marcaron su gobierno?',
            opciones: [
              'Conflictos internacionales',
              'Conflictos sociales (minería, comunidades indígenas)',
              'Conflictos religiosos',
              'Conflictos educativos',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Su gobierno enfrentó conflictos sociales relacionados con minería, comunidades indígenas y medio ambiente.',
          ),
          Pregunta(
            pregunta: '¿Qué problema afectó la imagen de su administración?',
            opciones: [
              'Baja inversión extranjera',
              'Corrupción y malas prácticas',
              'Aumento del desempleo',
              'Crisis alimentaria',
            ],
            respuestaCorrecta: 1,
            explicacion:
                'Su administración fue señalada por corrupción y malas prácticas que afectaron su legado.',
          ),
        ],
      ),

      // Puedes agregar más quizzes para otros presidentes...
    ];
  }

  static Quiz? obtenerQuizPorId(String id) {
    try {
      return obtenerQuizzes().firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Quiz> obtenerQuizzesPorPresidente(String nombrePresidente) {
    return obtenerQuizzes()
        .where((quiz) => quiz.presidenteRelacionado == nombrePresidente)
        .toList();
  }
}
