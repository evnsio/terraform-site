provider "cloudflare" {
    email = "${var.cloudflare_email}"
    token = "${var.cloudflare_token}"
}


# Add an A record to the domain:
#     A    <root-domain>    <public-ip>
resource "cloudflare_record" "root_a" {
    count = "${var.configure_cloudflare}"
    domain = "${var.root_domain}"
    name = "${var.root_domain}"
    value = "${aws_eip.web.public_ip}"
    type = "A"
    proxied = "true"
}


# Add an CNAME record to the domain:
#     CNAME    www    <root-domain>
resource "cloudflare_record" "www_cname" {
    count = "${var.configure_cloudflare}"
    domain = "${var.root_domain}"
    name = "www"
    value = "${var.root_domain}"
    type = "CNAME"
    proxied = "true"
}