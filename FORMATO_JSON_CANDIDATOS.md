# 📋 Formato JSON para Actualizar Biografías de Precandidatos

## 🎯 Prompt Ideal para Enviar

Copia y pega este prompt, luego reemplaza el JSON con tus datos:

```
Actualiza las biografías de los precandidatos con la siguiente información en formato JSON:

[PEGA AQUÍ TU JSON]

Por favor actualiza el archivo lib/models/candidato.dart en el método getBiografiasPersonalizadas() con esta información.
```

---

## 📝 Formato JSON Completo

```json
{
  "partidos": [
    {
      "id": "accion_popular",
      "nombre": "Acción Popular",
      "candidatos": {
        "presidente": {
          "nombre": "Juan Pérez García",
          "hojaVida": [
            "Economista, Universidad del Pacífico",
            "MBA en Harvard Business School",
            "Ex Ministro de Economía y Finanzas (2018-2020)",
            "Docente universitario por 20 años",
            "Autor de 5 libros sobre economía peruana"
          ],
          "biografia": "Reconocido economista con amplia trayectoria académica y en gestión pública. Durante su gestión como Ministro de Economía implementó políticas de estabilización económica que redujeron la inflación. Propone un modelo de desarrollo inclusivo con énfasis en educación, tecnología e innovación para el crecimiento sostenible del país."
        },
        "vicepresidente1": {
          "nombre": "María López Sánchez",
          "hojaVida": [
            "Abogada, Pontificia Universidad Católica del Perú",
            "Maestría en Derechos Humanos, Universidad de Salamanca",
            "Ex Defensora del Pueblo (2016-2021)",
            "Activista social por 15 años"
          ],
          "biografia": "Destacada abogada especializada en derechos humanos y justicia social. Como Defensora del Pueblo lideró importantes reformas en el sistema de justicia. Propone fortalecer las instituciones democráticas y garantizar el acceso a la justicia para todos los peruanos."
        },
        "vicepresidente2": {
          "nombre": "Carlos Rodríguez Torres",
          "hojaVida": [
            "Ingeniero Civil, Universidad Nacional de Ingeniería",
            "MBA, ESAN",
            "Ex Ministro de Transportes y Comunicaciones",
            "Experiencia en infraestructura por 25 años"
          ],
          "biografia": "Ingeniero con amplia experiencia en gestión de infraestructura y desarrollo de proyectos de gran envergadura. Propone un plan ambicioso de conectividad para mejorar la competitividad del país."
        },
        "representante": {
          "nombre": "Roberto Martínez Flores",
          "hojaVida": [
            "Abogado especializado en derecho electoral",
            "Secretario General del Partido",
            "Más de 15 años de experiencia en derecho constitucional"
          ],
          "biografia": "Representante legal del partido político con amplia trayectoria en derecho electoral y constitucional. Ha participado en múltiples procesos electorales como asesor legal."
        }
      }
    },
    {
      "id": "fuerza_popular",
      "nombre": "Fuerza Popular",
      "candidatos": {
        "presidente": {
          "nombre": "Keiko Fujimori Higuchi",
          "hojaVida": [
            "Administradora de empresas, Boston University",
            "Congresista de la República (2006-2011)",
            "Lideresa del partido Fuerza Popular",
            "Candidata presidencial en 2011, 2016 y 2021"
          ],
          "biografia": "Lideresa política con amplia experiencia electoral y parlamentaria. Su plan de gobierno se centra en la seguridad ciudadana, reactivación económica y lucha contra la corrupción."
        }
      }
    }
  ]
}
```

---

## 🎨 Formato JSON Simplificado (Mínimo)

Si solo quieres actualizar algunos candidatos:

```json
{
  "partidos": [
    {
      "id": "accion_popular",
      "candidatos": {
        "presidente": {
          "nombre": "Nombre Completo",
          "hojaVida": [
            "Punto 1",
            "Punto 2",
            "Punto 3"
          ],
          "biografia": "Biografía completa aquí..."
        }
      }
    }
  ]
}
```

---

## 📋 IDs de Partidos Disponibles

Usa estos IDs exactos en el campo `"id"`:

- `accion_popular`
- `fuerza_popular`
- `alianza_para_el_progreso`
- `partido_morado`
- `renovacion_popular`
- `avanza_pais`
- `juntos_por_el_peru`
- `podemos_peru`
- `somos_peru`
- `peru_libre`
- `frente_amplio`
- `partido_nacionalista`
- `union_por_el_peru`
- `victoria_nacional`
- `todos_por_el_peru`

---

## 🎯 Cargos Disponibles

Usa estos nombres exactos en `"candidatos"`:

- `presidente` → Candidato a Presidente
- `vicepresidente1` → Primer Vicepresidente
- `vicepresidente2` → Segundo Vicepresidente
- `representante` → Representante Legal

---

## ✅ Ejemplo Real: Múltiples Partidos

```json
{
  "partidos": [
    {
      "id": "renovacion_popular",
      "candidatos": {
        "presidente": {
          "nombre": "Rafael López Aliaga",
          "hojaVida": [
            "Empresario y político peruano",
            "Ingeniero Industrial, Universidad de Lima",
            "MBA, ESAN",
            "Ex candidato a la alcaldía de Lima"
          ],
          "biografia": "Empresario con amplia trayectoria en el sector privado. Fundador y líder del partido Renovación Popular. Propone un modelo económico liberal con reducción del Estado y promoción de la inversión privada."
        },
        "vicepresidente1": {
          "nombre": "Patricia Chirinos Venegas",
          "hojaVida": [
            "Congresista de la República",
            "Empresaria",
            "Activista política"
          ],
          "biografia": "Congresista con experiencia en el sector empresarial. Propone políticas de desarrollo económico y fortalecimiento institucional."
        }
      }
    },
    {
      "id": "partido_morado",
      "candidatos": {
        "presidente": {
          "nombre": "Julio Guzmán Cáceres",
          "hojaVida": [
            "Economista, Universidad del Pacífico",
            "Maestría en Políticas Públicas, Georgetown University",
            "Ex funcionario del Banco Mundial",
            "Fundador del Partido Morado"
          ],
          "biografia": "Economista y político con experiencia en organismos internacionales. Propone un modelo de desarrollo basado en la meritocracia, transparencia y lucha contra la corrupción."
        }
      }
    }
  ]
}
```

---

## 💡 Consejos para el JSON

### ✅ Hacer:
- Usa comillas dobles `"` para todo
- Separa items de array con comas
- Usa arrays `[]` para la hoja de vida (cada punto es un item)
- Mantén el formato de indentación
- Verifica que el JSON sea válido en [jsonlint.com](https://jsonlint.com)

### ❌ Evitar:
- No uses comillas simples `'`
- No pongas coma después del último elemento
- No uses saltos de línea dentro de strings (usa espacios)
- No uses caracteres especiales sin escapar

---

## 🚀 Ejemplo de Prompt Completo

```
Actualiza las biografías de los precandidatos con la siguiente información en formato JSON:

{
  "partidos": [
    {
      "id": "accion_popular",
      "candidatos": {
        "presidente": {
          "nombre": "Raúl Diez Canseco Terry",
          "hojaVida": [
            "Economista, Universidad del Pacífico",
            "MBA en Harvard Business School",
            "Ex Ministro de Economía y Finanzas",
            "Docente universitario por 20 años"
          ],
          "biografia": "Reconocido economista con amplia trayectoria académica y en gestión pública. Propone un modelo de desarrollo inclusivo con énfasis en educación y tecnología."
        }
      }
    },
    {
      "id": "fuerza_popular",
      "candidatos": {
        "presidente": {
          "nombre": "Keiko Fujimori Higuchi",
          "hojaVida": [
            "Administradora de empresas, Boston University",
            "Congresista de la República (2006-2011)",
            "Lideresa del partido Fuerza Popular"
          ],
          "biografia": "Lideresa política con amplia experiencia electoral. Su plan se centra en seguridad ciudadana y reactivación económica."
        }
      }
    }
  ]
}

Por favor actualiza el archivo lib/models/candidato.dart en el método getBiografiasPersonalizadas() con esta información.
```

---

## 🔍 Validar tu JSON

Antes de enviar, valida tu JSON en:
- [JSONLint](https://jsonlint.com)
- [JSON Formatter](https://jsonformatter.org)

---

## 📞 Soporte

Si tienes dudas sobre:
- **IDs de partidos**: Revisa `lib/models/partido_politico.dart`
- **Formato**: Consulta este archivo
- **Errores**: Valida tu JSON en jsonlint.com
