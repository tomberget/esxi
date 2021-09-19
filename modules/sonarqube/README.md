# SonarQube module

## Version and source

* **Version**      : `9.6.5`
* **Chart source** : [artifacthub.io](https://artifacthub.io/packages/helm/oteemo-charts/sonarqube)
* **Repository**   : [github.com](https://github.com/Oteemo/charts)
<!-- Pinning chart source to the version used is beneficial both for quickly being forwarded to the version of the source used. -->

## Documentation

### Dockyard Enhancement Proposal(s)

| What                 | Document         | Date implemented |
| -------------------- | ---------------- | ---------------- |
| Original proposal    |  |  |

### Confluence documentation

| What               | Document         |
| ------------------ | ---------------- |
| Get started | [Sonar](https://wiki.fiskeridirektoratet.no/display/SYS/Sonar) |
| Production readiness | [Veileder for Produksjonsklarhet](https://wiki.fiskeridirektoratet.no/display/IT/Veileder+for+Produksjonsklarhet#VeilederforProduksjonsklarhet-2.3SonarsjekkavkodekvalitetiJenkinsbygg) |

### Technical description of module

*Describe how the the module is created and used in the Dockyard clusters.*

## Module idiosyncrasies

*Any special information necessary that sets this module apart from the other modules.*

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.sonarqube](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_sonar_chart_repository"></a> [sonar\_chart\_repository](#input\_sonar\_chart\_repository) | The chart repository used for SonarQube. | `string` | n/a | yes |
| <a name="input_sonar_chart_version"></a> [sonar\_chart\_version](#input\_sonar\_chart\_version) | The Helm chart version used for sonar. | `string` | `"9.8.0"` | no |
| <a name="input_sonar_enabled"></a> [sonar\_enabled](#input\_sonar\_enabled) | Enable or disable the SonarQube module | `bool` | `false` | no |
| <a name="input_sonar_image_tag"></a> [sonar\_image\_tag](#input\_sonar\_image\_tag) | Set the SonarQube image tag. Must be overridden in TFvars, as the default is always a -community image. | `string` | n/a | yes |
| <a name="input_sonar_ingress_host"></a> [sonar\_ingress\_host](#input\_sonar\_ingress\_host) | The ingress host where sonar will be made available. | `string` | n/a | yes |
| <a name="input_sonar_ldap_bind_password"></a> [sonar\_ldap\_bind\_password](#input\_sonar\_ldap\_bind\_password) | The Encrypted LDAP Bind password created by SonarQube. Can be set only after it has been created in SonarQube. | `string` | `""` | no |
| <a name="input_sonar_namespace"></a> [sonar\_namespace](#input\_sonar\_namespace) | SonarQube namespace. | `string` | `"sonar"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->