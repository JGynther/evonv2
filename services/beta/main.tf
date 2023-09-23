module "beta-backend" {
  source = "./backend"
}

output "content-table-arn" {
  value = module.beta-backend.content-table-arn
}

output "author-table-arn" {
  value = module.beta-backend.author-table-arn
}

output "blog-table-arn" {
  value = module.beta-backend.blog-table-arn
}
