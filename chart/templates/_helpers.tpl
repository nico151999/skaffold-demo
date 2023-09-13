{{/*
Expand the name of the chart.
*/}}
{{- define "skaffold-demo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "skaffold-demo.backend.name" -}}
{{- printf "%s-%s" "backend" (include "skaffold-demo.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "skaffold-demo.frontend.name" -}}
{{- printf "%s-%s" "frontend" (include "skaffold-demo.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "skaffold-demo.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}
{{- define "skaffold-demo.backend.fullname" -}}
{{- printf "%s-%s" "backend" (include "skaffold-demo.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "skaffold-demo.frontend.fullname" -}}
{{- printf "%s-%s" "frontend" (include "skaffold-demo.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "skaffold-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "skaffold-demo.labels" -}}
helm.sh/chart: {{ include "skaffold-demo.chart" . }}
{{ include "skaffold-demo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "skaffold-demo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "skaffold-demo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- define "skaffold-demo.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "skaffold-demo.backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- define "skaffold-demo.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "skaffold-demo.frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
