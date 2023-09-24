
resource "aws_ssm_parameter" "dbpwd" {
  name  = "/A4L/Wordpress/DBPassword"
  type  = "String"
  value = "myDBpassword"
}

resource "aws_ssm_parameter" "dbrootpwd" {
  name  = "/A4L/Wordpress/DBRootPassword"
  type  = "String"
  value = "myDBpassword"
}

resource "aws_ssm_parameter" "dbuser" {
  name  = "/A4L/Wordpress/DBUser"
  type  = "String"
  value = "wordpressuser"
}

resource "aws_ssm_parameter" "dbname" {
  name  = "/A4L/Wordpress/DBName"
  type  = "String"
  value = "wordpressdb"
}

resource "aws_ssm_parameter" "dbendpoint" {
  name  = "/A4L/Wordpress/DBEndpoint"
  type  = "String"
  value = local.threetiersdb_endpoint
}
