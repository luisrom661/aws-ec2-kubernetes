# Proyecto de Infraestructura con Terraform, AWS, Kubernetes y Ansible

Este proyecto utiliza Terraform para crear la infraestructura necesaria para dos instancias EC2 en AWS. Una instancia actúa como el nodo maestro de Kubernetes y la otra como el nodo trabajador. Además, se utiliza Ansible para instalar Docker y Kubernetes en ambas máquinas.

## Requisitos

- Terraform
- AWS CLI
- Ansible
- Cuenta de AWS

## Configuración

1. Configura tu AWS CLI con tus credenciales de AWS.
2. Clona este repositorio.
3. Navega hasta el directorio del proyecto.
4. Ejecuta `terraform init` para inicializar tu entorno de Terraform.
5. Ejecuta `terraform apply` para crear la infraestructura en AWS.

## Despliegue de Kubernetes

Una vez que la infraestructura está en su lugar, puedes usar Ansible para instalar Docker y Kubernetes en las instancias EC2.

1. Navega hasta el directorio de Ansible en el proyecto.
2. Ejecuta `ansible-playbook playbook.yml` para iniciar el despliegue.

## Contribuir

Las contribuciones son bienvenidas. Por favor, abre un issue o pull request para sugerencias o mejoras.

## Licencia

Este proyecto está bajo la licencia MIT.