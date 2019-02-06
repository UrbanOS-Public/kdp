{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kdp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "kdp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified presto name.
*/}}
{{- define "kdp.presto.fullname" -}}
{{- if .Values.presto.fullnameOverride -}}
{{- .Values.presto.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name "presto" | trunc 63 | trimSuffix "-"}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name "presto" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified metastore name.
*/}}
{{- define "kdp.metastore.fullname" -}}
{{- if .Values.metastore.fullnameOverride -}}
{{- .Values.metastore.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name "metastore" | trunc 63 | trimSuffix "-"}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name "metastore" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified hive name.
*/}}
{{- define "kdp.hive.fullname" -}}
{{- if .Values.hive.fullnameOverride -}}
{{- .Values.hive.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name "hive" | trunc 63 | trimSuffix "-"}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name "hive" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified postgres name.
*/}}
{{- define "kdp.postgres.fullname" -}}
{{- if .Values.postgres.fullnameOverride -}}
{{- .Values.postgres.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name "postgres" | trunc 63 | trimSuffix "-"}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name "postgres" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified minio name.
*/}}
{{- define "kdp.minio.fullname" -}}
{{- if .Values.minio.fullnameOverride -}}
{{- .Values.minio.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name "minio" | trunc 63 | trimSuffix "-"}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name "minio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the platform
*/}}
{{- define "kdp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "kdp.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a common label block
*/}}
{{- define "kdp.labels" -}}
environment: {{ .Values.global.environment }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
release: {{ .Release.Name }}
source: helm
{{- end -}}
