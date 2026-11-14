
module "networking" {
  source             = "./modules/networking"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  cluster_name       = var.cluster_name
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  environment  = var.environment
}

module "eks" {
  source                      = "./modules/eks"
  cluster_name                = var.cluster_name
  subnet_ids                  = module.networking.private_subnet_ids
  cluster_version             = var.cluster_version
  environment                 = var.environment
  cluster_public_access_cidrs = var.cluster_public_access_cidrs

}