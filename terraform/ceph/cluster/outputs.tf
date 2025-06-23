# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

output "ceph_csi" {
  description = "Object of the ceph-csi application."
  value       = module.ceph_csi
}

output "debug" {
  value = {
    mon = module.ceph_mon
    osd = module.ceph_osd
    csi = module.ceph_csi
  }
}
