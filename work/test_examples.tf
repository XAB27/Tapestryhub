# Test file for daily_cost validation
# This file contains examples of valid and invalid coder_metadata resources

# ✅ VALID: Has daily_cost property with positive number
resource "coder_metadata" "workspace_info" {
  resource_id = "workspace-123"
  daily_cost  = 100
  description = "Workspace cost tracking"
}

# ✅ VALID: Has daily_cost property with decimal value
resource "coder_metadata" "compute_instance" {
  resource_id = "instance-456"
  daily_cost  = 25.50
  description = "Compute instance cost"
}

# ❌ INVALID: Missing daily_cost property
resource "coder_metadata" "missing_cost" {
  resource_id = "resource-789"
  description = "This resource is missing daily_cost"
}

# ❌ INVALID: Has daily_cost but value is zero
resource "coder_metadata" "zero_cost" {
  resource_id = "resource-101"
  daily_cost  = 0
  description = "Zero cost resource"
}

# ❌ INVALID: Has daily_cost but value is negative
resource "coder_metadata" "negative_cost" {
  resource_id = "resource-202"
  daily_cost  = -50
  description = "Negative cost resource"
}

# ❌ INVALID: Has daily_cost but value is not a number
resource "coder_metadata" "invalid_cost" {
  resource_id = "resource-303"
  daily_cost  = "not_a_number"
  description = "Invalid cost value"
}

# ✅ VALID: Has daily_cost property with large positive number
resource "coder_metadata" "high_cost_resource" {
  resource_id = "resource-404"
  daily_cost  = 1000
  description = "High cost resource"
}
