{{- define "podinfo.name" -}}
{{- default .Chart.Name .Values.nameOverride | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "podinfo.labels" -}}
app: {{ include "podinfo.name" . }}
version: {{ .Chart.Version | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "podinfo.selectorLabels" -}}
app: {{ include "podinfo.name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "podinfo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "podinfo.name" .) .Values.serviceAccount.name }}
{{- else -}}
{{- default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
