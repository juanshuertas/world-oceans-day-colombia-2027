# Integración con OLEA

## Enlaces oficiales

- Observatorio publicado: <https://juanshuertas.github.io/antarctic-maritime-observation-hub/olea/>
- Repositorio de OLEA: <https://github.com/juanshuertas/antarctic-maritime-observation-hub>
- Repositorio de gestión del programa: <https://github.com/juanshuertas/world-oceans-day-colombia-2027>

## Propósito y límites

OLEA (Observatory for Linked Evidence in Antarctica) aporta contexto científico y geoespacial para los ejes de criósfera, ciencia antártica, observación satelital y AIS. El repositorio World Oceans Day & Month Colombia 2027 conserva la autoridad documental para gobernanza, compromisos, presupuesto, cronogramas y ejecución.

La integración vigente es una conexión de navegación y documentación. No hay un contrato de API publicado que sincronice automáticamente las cifras financieras, las sedes, los asistentes, el estado de los issues o los resultados de restauración con OLEA. No describir esos datos como sincronizados ni como telemetría en vivo.

## Contrato de intercambio futuro

Antes de publicar una integración de datos:

1. Identificar endpoint y responsable en el repositorio OLEA.
2. Definir esquema versionado, identificadores estables y fechas en UTC.
3. Incluir procedencia, licencia, fecha de actualización, método y nivel de incertidumbre.
4. No exponer datos personales, información sensible de seguridad ni datos financieros no aprobados.
5. Distinguir estimaciones, objetivos, compromisos y resultados verificados.
6. Validar las transformaciones y mostrar fallos de actualización; no sustituirlos silenciosamente por valores de demostración.
7. Obtener aprobación de los responsables de datos y de ambos repositorios antes del despliegue.

## Enlaces dentro de las interfaces

- Este repositorio enlaza al observatorio en el encabezado del [README principal](../README.md).
- OLEA incluirá un acceso externo al repositorio de gestión del programa en su navegación.

La presencia del acceso no implica aprobación de patrocinios, alianzas, actividades ni certificaciones; esos estados solo se afirman con evidencia registrada en los issues y documentos del programa.
