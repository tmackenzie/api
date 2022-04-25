resource "aws_route53_record" "api_record" {
  zone_id = "${data.terraform_remote_state.platform.outputs.public_zone.zone_id}"
  name    = "api.${var.domain_name}"
  type    = "A"
  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = true
  }
}