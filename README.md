# BUG DESCRIPTION:
OpenTofu 1.9.0+ incorrectly handles data source dependencies during destroy operations when the data source
uses for_each with computed values and the output is passed to a module with validation rules.

##  ISSUE DETAILS:
- The data source value is known during the plan phase
- Module validation should pass since the value is available
- During destroy, OpenTofu incorrectly treats the data source as "unknown" 
- This causes a "for_each" validation error even though the resource already exists

## AFFECTED VERSIONS:
- ✅ Works correctly: OpenTofu 1.8.9, Terraform (all versions)
- ❌ Broken: OpenTofu >= 1.9.0

## STEPS TO REPRODUCE:
1. Setup AWS credentials and run `tofu init`
2. Apply configuration with OpenTofu 1.8.9: `tofu apply` → ✅ Success
3. Destroy with OpenTofu 1.8.9: `tofu destroy` → ✅ Success  
4. Apply configuration with OpenTofu 1.9.0+: `tofu apply` → ✅ Success
5. Destroy with OpenTofu 1.9.0+: `tofu destroy` → ❌ Error:

```text
│ Error: Invalid for_each argument
│
│   on main.tf line 31, in data "aws_iam_role" "organization_account_access_role":
│   31:   for_each = {
│   32:     for role in data.aws_iam_roles.all.names : role => role
│   33:     if role == "OrganizationAccountAccessRole"
│   34:   }
│     ├────────────────
│     │ data.aws_iam_roles.all.names is a set of string, known only after apply
│
│ The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, and so OpenTofu cannot determine the full set of keys that will identify the instances of this resource.
│
│ When working with unknown values in for_each, it's better to define the map keys statically in your configuration and place apply-time results only in the map values.
│
│ Alternatively, you could use the -target planning option to first apply only the resources that the for_each value depends on, and then apply a second time to fully converge.
```

## RELATED LINKS:
This issue was introduced with opentofu 1.9.0
- https://github.com/opentofu/opentofu/releases/tag/v1.9.0
- https://github.com/opentofu/opentofu/blob/v1.9.0/CHANGELOG.md