{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- $selectorLabels := include "chart.selectorLabels" . -}}
# Kubernetes Service
{{- range $containers := .Values.containers }}
{{- if and $containers.service ( $containers.service.enabled | default false ) }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ (list $fullName $containers.name  | join "-") }} 
  labels:
    {{- $labels | nindent 4 }}
  {{- with $containers.service.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  type: {{ $containers.service.type }}
  ports:
    {{- range $ports := $containers.service.ports }}
    - port: {{ $ports.port }}
      targetPort: {{ $ports.targetPort }}
      protocol: {{ $ports.protocol }}
      name: {{ $ports.name }}
      {{- if and (eq $containers.service.type "NodePort") $ports.nodePort }}
      nodePort: {{ $ports.nodePort }}
      {{- end }}
    {{- end }}
  selector:
    {{- $selectorLabels | nindent 4 }}
{{- end }}
{{- end }}
# Headless Kubernetes Service
{{- if eq .Values.kind "StatefulSet" }}
{{- range $containers := .Values.containers }}
{{- if and $containers.service ( $containers.service.enabled | default false ) }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ (list $fullName $containers.name "headless"  | join "-") }}
  labels:
    {{- $labels | nindent 4 }}
  {{- with $containers.service.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  clusterIP: None
  ports:
    {{- range $ports := $containers.service.ports }}
    - port: {{ $ports.port }}
      targetPort: {{ $ports.targetPort }}
      protocol: {{ $ports.protocol }}
      name: {{ $ports.name }}
    {{- end }}
  selector:
    {{- $selectorLabels | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}
