import {
  to = module.rds.aws_security_group.main
  id = "sg-0df547632ff4abdc5"
}

import {
  to = module.rds.aws_db_subnet_group.main
  id = "engli3m-db-subnet-group"
}

import {
  to = module.rds.aws_db_instance.main
  id = "engli3m-db"
}