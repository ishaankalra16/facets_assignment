terraform {
  required_providers {
    time = {
      source = "hashicorp/time"
      version = "0.7.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

provider "time" {
  # Configuration options
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
