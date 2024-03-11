---
title: Services and Software
---

Services and software in use by the Rocky Linux project

## Self-Hosted Services

| **Item**        | **Use**                        | **Status** | **License**             | **Link**                                             |
|-----------------|--------------------------------|------------|-------------------------|------------------------------------------------------|
| **Ansible**     | Configuration management       | Deployed   | GPL-3.0                 | https://ansible.com                                  |
| **FreeIPA**     | Identity Management            | Deployed   | GPL-3.0                 | https://www.freeipa.org                              |
| **KeyCloak**    | SSO System                     | Deployed   | Apache License 2.0      | https://keycloak.org                                 |
| **Netbox**      | IPAM                           |            | Apache-2.0              | https://github.com/netbox-community/netbox           |
| -               | Logging                        | -          | -                       | -                                                    |
| **Prometheus**  | Monitoring                     | Planned    | Apache-2.0              | https://prometheus.io                                |
| **Koji**        | Distro packaging               | Deployed   | LGPL-2.1                | https://fedoraproject.org/wiki/Koji                  |
| **Mattermost**  | Communications                 | Deployed   | Mattermost EE           | https://mattermost.com                               |
| **Mock**        | Distro packaging               |            | GPL-2.0                 | https://github.com/rpm-software-management/mock/wiki |
| **GitLab EE**   | Distro Packaging               | Deployed   | MIT + GitLab EE License | https://gitlab.com                                   |
| **Gitea**       | Community Git Forge            | Deployed   | MIT                     | https://gitea.io                                     |
| **OpenProject** | Project management             | Deployed   | GPL-3.0                 | https://www.openproject.org                          |
| -               | SIEM                           | -          | -                       | -                                                    |
| **Wiki.js**     | Documentation                  | Removed    | AGPL-3.0                | https://wiki.js.org                                  |
| **Postgresql**  | Database Engine  >v11          | Deployed   |  ?                      | https://www.postgresql.org/                          |
| **Bugzilla**    | Bug Tracking and Ticket System | Removed    | MPL                     | https://bugzilla.org                                 |
| **MantisBT**    | Bug Tracking and Ticket System | Deployed   | GPL-2.0                 | https://mantisbt.org                                 |
| **mailman3**    | mailing list system            | Deployed   | GPL-3.0                 | https://www.list.org/                                |
| **hyperkitty**  | mailing list system achiver    | Deployed   | GPL-3.0                 | https://www.list.org/                                |
| **Peridot**     | Distro packaging               | Deployed   | BSD-3-Clause            | https://github.com/rocky-linux/peridot               |

## Third-Party Services

| **Item**             | **Use**                                          | **Status** |  **Terms**   | **Link**                               |
|----------------------|--------------------------------------------------|------------|--------------|----------------------------------------|
| **reCAPTCHA**        | Anti-abuse                                       | In use     |<sup>[1]</sup>| https://www.google.com/recaptcha/about |
| **Slack**            | Communications, chat                             | Deprecated |<sup>[2]</sup>| https://www.slack.com                  |
| **Libera**           | IRC, chat                                        | In use     |<sup>[3]</sup>| https://www.libera.chat                |
| **Matrix**           | Chat                                             | Deprecated |<sup>[4]</sup>| https://matrix.org                     |
| **GitHub**           | Source control, collaboration, registry, actions | In use     |<sup>[5]</sup>| https://www.github.com                 |
| **Figma**            | Design collaboration                             | In use     |<sup>[6]</sup>| https://figma.com                      |
| **Discourse**        | Community forums                                 | In use     |<sup>[7]</sup>| https://www.discourse.org              |
| **Google Workspace** | Foundation email                                 | In use     |<sup>[8]</sup>| https://workspace.google.com           |

<sup>[1]</sup> - Google [legal terms](https://developers.google.com/terms), [privacy policy](https://policies.google.com/privacy)
<sup>[2]</sup> - Slack [legal terms](https://slack.com/intl/en-us/legal)
<sup>[3]</sup> - Libera [bylaws](https://libera.chat/bylaws/) and [policies](https://libera.chat/policies/)
<sup>[4]</sup> - Matrix [legal terms](https://matrix.org/legal/)
<sup>[5]</sup> - GitHub [terms of service](https://docs.github.com/en/free-pro-team@latest/github/site-policy/github-terms-of-service), [privacy policy](https://docs.github.com/en/free-pro-team@latest/github/site-policy/github-privacy-statement)
<sup>[6]</sup> - Figma [legal terms](https://www.figma.com/tos/), [privacy policy](https://www.figma.com/privacy/)
<sup>[7]</sup> - Discourse [legal terms](https://meta.discourse.org/tos), [privacy policy](https://www.discourse.org/privacy)
<sup>[8]</sup> - Google Workspace legal terms [free](https://workspace.google.com/terms/standard_terms.html), [paid](https://workspace.google.com/terms/2013/1/premier_terms.html), [additional services](https://workspace.google.com/intl/en/terms/additional_services.html), [privacy policy](https://policies.google.com/privacy)


## Infrastructure Software

| **Item**      | **Use**                | **Status** | **License**        | **Link**                       |
|---------------|------------------------|------------|--------------------|--------------------------------|
| **Terraform** | Infrastructure as code | In use     | MPL-2.0            | https://www.terraform.io       |
| **Rocky 8**   | Operating system       | In use     | BSD-3, various OSI | https://www.rockylinux.org     |
| **Rocky 9**   | Operating system       | In use     | BSD-3, various OSI | https://www.rockylinux.org     |
| **KVM**       | Virtualization         | In use     | GPL-2.0 or LGPL    | https://www.linux-kvm.org      |
| **AWX**       | Automation System      | Planned    | Apache License 2.0 | https://github.com/ansible/awx |

## Infrastructure Providers

| **Item**                | **Use**        | **Status** | **Terms**    | **Link**                    |
|-------------------------|----------------|------------|--------------|-----------------------------|
| **Amazon Web Services** | Infrastructure | In use     |<sup>[1]</sup>| https://aws.amazon.com      |
| **Clouvider**           | Infrastructure | In use     |<sup>[2]</sup>| https://www.clouvider.co.uk |
| **Spry Servers**        | Infrastructure |            |<sup>[3]</sup>| https://www.spryservers.net |
| **Vercel**              | Web hosting    | In use     |<sup>[4]</sup>| https://vercel.com          |
| **Equinix**             | Infrastructure | In use     |<sup>[5]</sup>| https://equinix.com/        |
<sup>[1]</sup> - Amazon Web Services [legal terms](https://aws.amazon.com/service-terms/), [privacy policy](https://aws.amazon.com/privacy/)
<sup>[2]</sup> - Clouvider [legal terms](https://www.clouvider.co.uk/terms-conditions/), [privacy policy](https://www.clouvider.co.uk/privacy-and-cookies-policy/)
<sup>[3]</sup> - Spry Servers [legal terms](https://www.spryservers.net/legal/)
<sup>[4]</sup> - Vercel [legal terms](https://vercel.com/legal/terms), [privacy policy](https://vercel.com/legal/privacy-policy)
<sup>[5]</sup> - Equinix [legal terms](https://www.equinix.com/about/legal/terms), [privacy policy](https://www.equinix.com/about/legal/privacy)
