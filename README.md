# Proyecto de Infraestructura con Terraform, AWS, Kubernetes y Ansible

![devsecops](/img/configuración_para_terraform_para_aws_ec2.jpg)

Este proyecto utiliza Terraform para crear la infraestructura necesaria para dos instancias EC2 en AWS. Una instancia actúa como el nodo maestro de Kubernetes y la otra como el nodo trabajador. Además, se utiliza Ansible para instalar Docker y Kubernetes en ambas máquinas.

## Requisitos

- Terraform
- AWS EC2
- Ansible
- Cuenta de AWS

## Configuración

1. Clona este repositorio.
2. Crea los archivos `terraform.tfvars` en el directorio raíz de terraform.
3. Configura tus credenciales de AWS en `terraform/terraform.tfvars`.
4. Configura la ruta de tus archivos de Ansible en `terraform/main.tf`.
4. Navega hasta el directorio del proyecto de terraform.
5. Ejecuta `terraform init` para inicializar tu entorno de Terraform.
6. Ejecuta `terraform plan` para ver los cambios que se realizarán en tu infraestructura.
7. Ejecuta `terraform apply` para crear la infraestructura en AWS.

## Despliegue de Kubernetes

Una vez que la infraestructura está en su lugar, puedes usar Ansible para instalar Docker y Kubernetes en las instancias EC2, en este caso, Terraform ya lo hace desde el momento que creas la infraestructura. por lo tanto, deberás realizar las siguientes configuraciones:

### Configuración del nodo maestro
1. Navega en el directorio del nodo maestro de Kubernetes
2. Ejecuta el comando `sudo hostnamectl set-hostname K8s-Master` para configurar el nombre del host.
3. Inicializa el clúster de Kubernetes con el comando `sudo kubeadm init --pod-network-cidr=10.244.0.0/16`.
4. Configura el entorno de Kubernetes con el comando `mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config`.
5. Instala el complemento de red de Kubernetes con el comando `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`.

### Configuración del nodo trabajador
1. Navega en el directorio del nodo trabajador de Kubernetes.
2. Ejecuta el comando `sudo hostnamectl set-hostname K8s-Worker` para configurar el nombre del host.
3. Únete al clúster de Kubernetes con el comando `sudo kubeadm join <master-node-ip>:<master-node-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>`, éste comando lo puedes encontrar como salida del comando `sudo kubeadm init --pod-network-cidr=10.244.0.0/16`.

## Contribuir

Las contribuciones son bienvenidas. Por favor, abre un issue o pull request para sugerencias o mejoras.

## Licencia

Este proyecto está bajo la licencia MIT.
