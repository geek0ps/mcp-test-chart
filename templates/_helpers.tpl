{{/*
Expand the name of the chart.
*/}}
{{- define "halo-mcp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "halo-mcp.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "halo-mcp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "halo-mcp.labels" -}}
helm.sh/chart: {{ include "halo-mcp.chart" . }}
{{ include "halo-mcp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "halo-mcp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "halo-mcp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component labels
*/}}
{{- define "halo-mcp.componentLabels" -}}
{{ include "halo-mcp.labels" . }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "halo-mcp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "halo-mcp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database connection string
*/}}
{{- define "halo-mcp.databaseUrl" -}}
{{- printf "postgresql://%s:%s@%s:%d/%s" .Values.config.database.username .Values.secrets.database.password (printf "%s-database" (include "halo-mcp.fullname" .)) (.Values.config.database.port | int) .Values.config.database.name }}
{{- end }}

{{/*
Redis connection string
*/}}
{{- define "halo-mcp.redisUrl" -}}
{{- printf "redis://:%s@%s:%d" .Values.secrets.redis.password (printf "%s-redis" (include "halo-mcp.fullname" .)) (.Values.config.redis.port | int) }}
{{- end }}