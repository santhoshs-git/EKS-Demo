output "endpoint_url" {
	value = aws_eks_cluster.aws_eks_demo.endpoint

}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.aws_eks_demo.certificate_authority 
}