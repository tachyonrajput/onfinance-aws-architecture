# terraform/modules/eks/main.tf (key components)
resource "aws_eks_cluster" "main" {
  name = "${var.project_name}-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  
  vpc_config {
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
    security_group_ids = [var.eks_control_plane_sg_id]
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = var.private_subnet_ids
  
  scaling_config {
    desired_size = var.node_desired_size
    max_size = var.node_max_size
    min_size = var.node_min_size
  }
}