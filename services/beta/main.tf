module "beta-backend" {
  source = "./backend"
}

output "author-table-arn" {
  value = module.beta-backend.author-table-arn
}

output "blog-table-arn" {
  value = module.beta-backend.blog-table-arn
}
