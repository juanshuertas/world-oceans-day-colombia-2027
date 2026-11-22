#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-juanshuertas/world-oceans-day-colombia-2027}"

gh issue list --repo "$REPO" --state open --limit 100 --json number,title,labels,assignees |
jq -c '.[]' |
while IFS= read -r issue; do
  number="$(jq -r '.number' <<<"$issue")"
  title="$(jq -r '.title' <<<"$issue")"
  assignees="$(jq -r '[.assignees[].login] | join(",")' <<<"$issue")"

  if [[ -n "$assignees" ]]; then
    continue
  fi

  case "$title" in
    *Gobernanza*|*presidencia*) agent="gobernanza-estado" ;;
    *Universitaria*|*Alianza*|*MAUA*) agent="maua-juvenil" ;;
    *Capital\ Semilla*|*4Ocean*|*Restauración*) agent="grants-finanzas" ;;
    *Ciencia\ Antártica*|*Comité\ Científico*|*IA\ y\ Agencias*) agent="ciencia-scar" ;;
    *Visita\ Técnica*) agent="naval-galeon" ;;
    *Ecosistema\ Circular*) agent="economia-circular-3d" ;;
    *Patrocinios*|*Free\ Press*) agent="patrocinios-pr" ;;
    *Cartagena\ Polo*) agent="produccion-cartagena" ;;
    *Certificación\ Blue*) agent="blue-standard" ;;
    *Integración*|*Documento*|*Drive*) agent="integracion-documental" ;;
    *) agent="coordinacion-general" ;;
  esac

  gh label create "agente:${agent}" --description "Delegado al agente ${agent}" --color "6F42C1" --force 2>/dev/null || true
  gh issue edit "$number" --repo "$REPO" --add-label "agente:${agent}" >/dev/null

  comment="Delegación automática: \`@${agent}\`. Sigue el perfil correspondiente en \`.github/agents/${agent}.agent.md\`. Actualiza este issue con evidencia, archivos modificados y criterios de aceptación cerrados."
  gh issue comment "$number" --repo "$REPO" --body "$comment" >/dev/null

  if gh issue edit "$number" --repo "$REPO" --add-assignee copilot-swe-agent >/dev/null 2>&1; then
    echo "Issue #${number} delegado a agente ${agent} y a Copilot"
  else
    echo "Issue #${number} delegado a agente ${agent}; Copilot no disponible para asignación directa"
  fi
done
