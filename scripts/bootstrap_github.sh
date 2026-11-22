#!/usr/bin/env bash
set -euo pipefail

OWNER="juanshuertas"
REPO="world-oceans-day-colombia-2027"
REMOTE="https://github.com/${OWNER}/${REPO}.git"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT"

echo "==> Verificando gh auth"
gh auth status

echo "==> Creando o verificando el repositorio"
if gh repo view "${OWNER}/${REPO}" >/dev/null 2>&1; then
  echo "Repositorio existente: ${OWNER}/${REPO}"
else
  gh repo create "${OWNER}/${REPO}" --public --description "Planificación, gobernanza y ejecución de World Oceans Day & Month Colombia 2027"
fi

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE"
else
  git remote add origin "$REMOTE"
fi

git add -A
if ! git diff --cached --quiet; then
  git -c user.name="Copilot" -c user.email="198982749+Copilot@users.noreply.github.com" \
    commit -m "chore: initialize World Oceans Day Colombia 2027" \
    -m "Co-authored-by: copilot-swe-agent[bot] <198982749+Copilot@users.noreply.github.com>"
fi

git branch -M main
git push -u origin main

echo "==> Creando etiquetas"
declare -A LABELS
LABELS["frente:gobernanza-estado"]="0052CC"
LABELS["frente:universidades-maua"]="1D76DB"
LABELS["frente:ciencia-naval-ia"]="5319E7"
LABELS["frente:4ocean-granjas-3d"]="0E8A16"
LABELS["frente:cartagena-polo-concierto"]="B60205"
LABELS["frente:blue-standard"]="006B75"
LABELS["frente:patrocinios-pr"]="FBCA04"
LABELS["frente:grants-finanzas"]="D93F0B"
LABELS["frente:fondo-ecop"]="C2E0C6"
LABELS["prioridad:critica"]="B60205"
LABELS["prioridad:alta"]="D93F0B"
LABELS["prioridad:media"]="FBCA04"

for label in "${!LABELS[@]}"; do
  gh label create "$label" --color "${LABELS[$label]}" --force
done

echo "==> Creando hitos"
create_milestone() {
  local title="$1"
  local due="$2"
  if gh api "repos/${OWNER}/${REPO}/milestones" --paginate --jq ".[] | select(.title == \"${title}\") | .title" | grep -Fxq "$title"; then
    echo "Hito existente: $title"
  else
    gh api --method POST "repos/${OWNER}/${REPO}/milestones" -f "title=${title}" -f "due_on=${due}" >/dev/null
    echo "Hito creado: $title"
  fi
}

create_milestone "M1 - Cierre Institucional, MOUs y Capital Semilla (Nov – Dic 2026)" "2026-12-31T23:59:59Z"
create_milestone "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" "2027-03-31T23:59:59Z"
create_milestone "M3 - Producción Cartagena, Auditoría Blue Standard y Patrocinios (Abr – May 2027)" "2027-05-31T23:59:59Z"
create_milestone "M4 - Ejecución Mes de los Océanos y Adjudicación Fondo ECOP (Jun – Jul 2027)" "2027-07-31T23:59:59Z"

create_issue() {
  local title="$1"
  local milestone="$2"
  local labels="$3"
  local assignee="$4"
  local body="$5"

  body="${body}"$'\n\n'"Delegado: @${assignee}"

  echo "==> Issue: $title"
  if existing="$(gh issue list --repo "${OWNER}/${REPO}" --search "in:title \"${title}\"" --json title --jq '.[0].title' 2>/dev/null)" && [[ "$existing" == "$title" ]]; then
    echo "Issue existente: $title"
    return
  fi

  local number
  number="$(gh issue create \
    --repo "${OWNER}/${REPO}" \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$milestone")"
  number="${number##*/}"
}

create_issue \
  "[Gobernanza y Estado] Radicar oficios oficiales ante Presidencia, Vicepresidencia, Cancillería y Ministerios" \
  "M1 - Cierre Institucional, MOUs y Capital Semilla (Nov – Dic 2026)" \
  "frente:gobernanza-estado,prioridad:critica" \
  "coordinacion-general" \
  "## Objetivo
Radicar oficios oficiales ante Presidencia, Vicepresidencia, Cancillería y los Ministerios para obtener declaratoria nacional y confirmar la Recepción Diplomática en Cartagena.

## Alcance
- Presidencia y Vicepresidencia.
- Cancillería y Palacio de la Proclamación.
- MinAmbiente, MinCiencias y MinDefensa/ARC/DIMAR/CCO.
- ProColombia.

## Criterios de aceptación
- Oficios radicados con acuse verificable.
- Declaratoria nacional con respaldo público o interno.
- Recepción Diplomática reservada con sede, fecha y delegado de protocolo.
- Minuta de mesa interinstitucional y responsable por entidad."

create_issue \
  "[Alianza Universitaria] Formalizar MOUs bilaterales y bloquear auditorios" \
  "M1 - Cierre Institucional, MOUs y Capital Semilla (Nov – Dic 2026)" \
  "frente:universidades-maua,prioridad:critica" \
  "coordinacion-general" \
  "## Objetivo
Formalizar MOUs con UMNG, Universidad de los Andes, ENAP, ESDEG, UJTL y Uninorte.

## Criterios de aceptación
- MOU bilateral firmado por cada institución.
- Auditorios UMNG bloqueados el 8 de junio.
- Auditorios Uniandes Cartagena bloqueados el 10 de junio.
- Matriz de aportes en especie conciliada por $74.500.000 COP.
- Vigencia, seguros, propiedad intelectual y responsables definidos."

create_issue \
  "[Socio Organizador MAUA] Activar plan de trabajo juvenil" \
  "M1 - Cierre Institucional, MOUs y Capital Semilla (Nov – Dic 2026)" \
  "frente:universidades-maua,prioridad:critica" \
  "maua-uniandes" \
  "## Objetivo
Activar MAUA como Socio Organizador Juvenil para el Hackatón Universitario Azul, brigadas estudiantiles y protocolo Punto Verde/SWAP.

## Criterios de aceptación
- Plan operativo MAUA aprobado.
- Comité organizador juvenil definido.
- Hackatón, brigadas y auditoría de plásticos calendarizados.
- Canal de reportes y responsables por nodo.
- Co-gestión de becas integrada al plan ECOP."

create_issue \
  "[Capital Semilla Inmediato] Radicar Waitt, Rufford y PPD-GEF PNUD" \
  "M1 - Cierre Institucional, MOUs y Capital Semilla (Nov – Dic 2026)" \
  "frente:grants-finanzas,prioridad:critica" \
  "finanzas-grants" \
  "## Objetivo
Redactar y someter postulaciones de arranque rápido a Waitt Foundation (ROC Grant, $20K USD), Rufford Small Grants ($15K USD) y PPD-GEF PNUD Colombia ($50K USD).

## Criterios de aceptación
- Convocatoria y elegibilidad verificadas por cada programa.
- Presupuesto, contrapartidas y teoría de cambio aprobados.
- Solicitudes radicadas con acuses.
- Tracker financiero con estado, monto y fecha actualizados."

create_issue \
  "[Ciencia Antártica y PAC] Estructurar propuestas National Geographic, Principado, SCAR/COMNAP/IAATO y MinCiencias" \
  "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" \
  "frente:ciencia-naval-ia,frente:grants-finanzas,prioridad:alta" \
  "comite-cientifico" \
  "## Objetivo
Estructurar propuestas de financiamiento polar ante National Geographic NG-LEX, Fundación Príncipe Alberto II/Polar Initiative, SCAR/COMNAP/IAATO y MinCiencias/CCO.

## Criterios de aceptación
- Cartera de 6 grants PAC actualizada.
- Conceptos científicos revisados y sin conflicto.
- Presupuestos y contrapartidas conciliados.
- Radicación y acuses registrados."

create_issue \
  "[Comité Científico SCAR] Configurar recepción de resúmenes y revisión doble ciego" \
  "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" \
  "frente:ciencia-naval-ia,prioridad:alta" \
  "comite-cientifico" \
  "## Objetivo
Configurar plataforma de recepción y revisión por pares doble ciego para los seis ejes temáticos con segregación LOC/ISC.

## Criterios de aceptación
- Convocatoria publicada y plataforma probada.
- Revisión doble ciego activada.
- Conflictos y delegación registrados.
- Criterios de aceptación y calendario publicados."

create_issue \
  "[Visita Técnica Naval y Galeón San José] Coordinar agenda 11 de junio" \
  "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" \
  "frente:ciencia-naval-ia,prioridad:alta" \
  "enlace-naval-estado" \
  "## Objetivo
Coordinar el protocolo de seguridad y agenda técnica del 11 de junio con Armada Nacional, ENAP, DIMAR/CIOH Caribe y COTECMAR/ARC Simón Bolívar.

## Criterios de aceptación
- Agenda aprobada por seguridad y responsables institucionales.
- Protocolo de DIMAR/CIOH Caribe y red REDMAR confirmado.
- COTECMAR y ARC Simón Bolívar confirmados.
- Coordinación legal y arqueológica del Proyecto Galeón San José documentada."

create_issue \
  "[IA y Agencias Espaciales] Formalizar mesas técnicas" \
  "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" \
  "frente:ciencia-naval-ia,prioridad:media" \
  "comite-cientifico" \
  "## Objetivo
Formalizar mesas técnicas con NASA PACE/SWOT, ESA/Copernicus, JAXA y FAC/CCE.

## Criterios de aceptación
- Reuniones calendarizadas y actas.
- Metadatos, licencias y gobernanza de datos aprobados.
- Casos Sentinel-2/5P, AIS y nanosatélites definidos.
- Ruta de cooperación y responsables establecidos."

create_issue \
  "[4Ocean y Restauración 12 Meses] Cerrar convenio y contratar operadores" \
  "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" \
  "frente:4ocean-granjas-3d,prioridad:critica" \
  "operaciones-ambientales" \
  "## Objetivo
Cerrar convenio operativo con 4Ocean Foundation y contratar operadores locales para limpieza bicoastal y restauración de 2.500 corales y 15.000 mangles.

## Criterios de aceptación
- Convenio 4Ocean firmado.
- Limpieza del 12 de junio calendarizada en 6 nodos y 2 inmersiones.
- Operadores locales contratados y seguros vigentes.
- Presupuesto de $260.000.000 COP desglosado y cronograma M1–M12 aprobado."

create_issue \
  "[Ecosistema Circular 3D] Adquirir y ensamblar maquinaria" \
  "M3 - Producción Cartagena, Auditoría Blue Standard y Patrocinios (Abr – May 2027)" \
  "frente:4ocean-granjas-3d,prioridad:alta" \
  "maua-uniandes" \
  "## Objetivo
Adquirir y ensamblar sistemas Precious Plastic, Polyformer y The Recreator 3D para demostraciones y 6 laboratorios juveniles costeros.

## Criterios de aceptación
- Inventario y ubicación de los 6 laboratorios definido.
- Máquinas adquiridas y pruebas documentadas.
- Seguridad eléctrica, térmica y de ventilación aprobada.
- Taller de operación y licencia de publicación definidos."

create_issue \
  "[Patrocinios Banca Azul y Movilidad] Cerrar alianzas corporativas" \
  "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" \
  "frente:patrocinios-pr,prioridad:critica" \
  "patrocinios-pr" \
  "## Objetivo
Cerrar acuerdos con BBVA, BMW/Tesla, LATAM, Corona e Isla Corona y National Geographic Society.

## Criterios de aceptación
- Contratos o cartas firmadas por cada aliado activo.
- Tarjeta Coral, flota cero emisiones, Avión Solidario y energía solar definidos.
- Derechos de marca, exclusividad y medición aprobados.
- Flujo efectivo y aportes en especie conciliados."

create_issue \
  "[Free Press Nacional e Internacional] Ejecutar plan de medios" \
  "M2 - Convocatoria SCAR, Grants PAC y Free Press EAU/Ámsterdam (Ene – Mar 2027)" \
  "frente:patrocinios-pr,prioridad:alta" \
  "patrocinios-pr" \
  "## Objetivo
Ejecutar el plan con Advance PR/Portafolio/Forbes y free press en Abu Dabi, Dubái y Ámsterdam.

## Criterios de aceptación
- Calendario editorial publicado.
- Voceros y mensajes aprobados.
- Pitches enviados a The National, Gulf News y SuperYacht Times.
- Métricas de alcance, cobertura y reproducciones registradas."

create_issue \
  "[Cartagena Polo Cup & Concierto Solar] Asegurar sedes y permisos" \
  "M3 - Producción Cartagena, Auditoría Blue Standard y Patrocinios (Abr – May 2027)" \
  "frente:cartagena-polo-concierto,prioridad:critica" \
  "produccion-cartagena" \
  "## Objetivo
Asegurar permisos, sedes, transporte y montaje solar de Cartagena.

## Criterios de aceptación
- Permisos DIMAR y Alcaldía aprobados.
- Convenios con Marinas Todomar y Santa Cruz firmados.
- Travesía a Isla Corona calendarizada.
- Castillogrande/Manzanillo, seguridad, moda y audiencia definidos.
- Rider Tesla con Powerwall/Megapack probado."

create_issue \
  "[Certificación Blue Standard y Fondo ECOP] Completar auditoría y abrir convocatoria" \
  "M3 - Producción Cartagena, Auditoría Blue Standard y Patrocinios (Abr – May 2027)" \
  "frente:blue-standard,frente:fondo-ecop,prioridad:alta" \
  "maua-uniandes" \
  "## Objetivo
Completar la auditoría 3 Estrellas de Oceanic Global en todas las sedes y abrir la convocatoria de las 20 becas y micro-grants ECOP por $280.000.000 COP.

## Criterios de aceptación
- Checklist 3 Estrellas cerrado por sede.
- Hallazgos críticos resueltos.
- Certificación Oceanic Global emitida o plan formalmente aceptado.
- Convocatoria ECOP publicada con criterios, montos y evaluación.
- Criterios de conflicto y co-administración MAUA/ECOP aprobados."

echo "Bootstrap completado."
