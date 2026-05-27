/* resource "aws_instance" "Sample" {
  count         = 2
  ami           = "ami-0138ef89268eafec8"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "HelloWorld-${count.index}"
  }
} */


variable "ec2" {
  type = map(string)

  default = {
    k1 = "t3.micro"
    //k2 = "t3.medium"
    //k3 = "t3.micro"
  }

}
resource "aws_instance" "Sample" {
  for_each                    = var.ec2
  ami                         = "ami-0138ef89268eafec8"
  instance_type               = each.value
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  key_name = "demo"

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "HelloWorld-${each.key}"
  }

  provisioner "file" {
    source      = "httpd.sh"
    destination = "/home/ec2-user/httpd.sh"

  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("keypair/demo.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("keypair/demo.pem")
      host        = self.public_ip
    }

    inline = [

      "chmod +x /home/ec2-user/httpd.sh ",
      "sudo /home/ec2-user/httpd.sh"

    ]
  }
}