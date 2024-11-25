# Déclare la variable ami_id
variable "ami_id" {
  description = "ID de l'AMI à utiliser"
  type        = string
}

# Déclare la variable subnets
variable "subnets" {
  description = "Liste des sous-réseaux à utiliser"
  type        = list(string)
}

# Déclare la variable asg_desired_capacity
variable "asg_desired_capacity" {
  description = "Capacité désirée de l'Auto Scaling Group"
  type        = number
}

# Déclare la variable asg_max_size
variable "asg_max_size" {
  description = "Taille maximale de l'Auto Scaling Group"
  type        = number
}

# Déclare la variable asg_min_size
variable "asg_min_size" {
  description = "Taille minimale de l'Auto Scaling Group"
  type        = number
}
