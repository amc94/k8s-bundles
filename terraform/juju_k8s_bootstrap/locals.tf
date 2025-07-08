locals {
  # Build bootstrap command arguments cleanly
  bootstrap_args = compact([
    try(var.bootstrap_options.no_browser_login, false) ? "--no-browser-login" : null,
    try(var.bootstrap_options.default_model, "") != "" ? "--default-model '${var.bootstrap_options.default_model}'" : null,
    try(var.bootstrap_options.agent_version, null) != null ? "--agent-version '${var.bootstrap_options.agent_version}'" : null,
    try(var.bootstrap_options.auto_upgrade, false) ? "--auto-upgrade" : null,
    try(var.bootstrap_options.build_agent, false) ? "--build-agent" : null,
    try(var.bootstrap_options.bootstrap_base, null) != null ? "--bootstrap-base '${var.bootstrap_options.bootstrap_base}'" : null,
    try(var.bootstrap_options.bootstrap_constraints, null) != null ? "--bootstrap-constraints '${var.bootstrap_options.bootstrap_constraints}'" : null,
    try(var.bootstrap_options.bootstrap_image, null) != null ? "--bootstrap-image '${var.bootstrap_options.bootstrap_image}'" : null,
    try(var.bootstrap_options.clouds, false) ? "--clouds" : null,
    try(var.bootstrap_options.regions, null) != null ? "--regions '${var.bootstrap_options.regions}'" : null,
    try(var.bootstrap_options.config, null) != null ? "--config '${var.bootstrap_options.config}'" : null,
    try(var.bootstrap_options.model_default, null) != null ? "--model-default '${var.bootstrap_options.model_default}'" : null,
    try(var.bootstrap_options.controller_charm_channel, null) != null ? "--controller-charm-channel '${var.bootstrap_options.controller_charm_channel}'" : null,
    try(var.bootstrap_options.controller_charm_path, null) != null ? "--controller-charm-path '${var.bootstrap_options.controller_charm_path}'" : null,
    try(var.bootstrap_options.credential, null) != null ? "--credential '${var.bootstrap_options.credential}'" : null,
    try(var.bootstrap_options.db_snap, null) != null ? "--db-snap '${var.bootstrap_options.db_snap}'" : null,
    try(var.bootstrap_options.db_snap_assert_file, null) != null ? "--db-snap-assert-file '${var.bootstrap_options.db_snap_assert_file}'" : null,
    try(var.bootstrap_options.force, false) ? "--force" : null,
    try(var.bootstrap_options.keep_broken, false) ? "--keep-broken" : null,
    try(var.bootstrap_options.metadata_source, null) != null ? "--metadata-source '${var.bootstrap_options.metadata_source}'" : null,
    try(var.bootstrap_options.no_switch, false) ? "--no-switch" : null,
    try(var.bootstrap_options.storage_pool, null) != null ? "--storage-pool '${var.bootstrap_options.storage_pool}'" : null,
    try(var.bootstrap_options.to, null) != null ? "--to '${var.bootstrap_options.to}'" : null,
    try(var.bootstrap_options.constraints, null) != null ? "--constraints '${join(",", var.bootstrap_options.constraints)}'" : null,
  ])

  k8s_args = compact([
    try(var.k8s-options.client, false) ? "--client" : null,
    try(var.k8s-options.cluster_name, null) != null ? "--cluster-name '${var.k8s-options.cluster_name}'" : null,
    try(var.k8s-options.context_name, null) != null ? "--context-name '${var.k8s-options.context_name}'" : null,
    try(var.k8s-options.credential, null) != null ? "--credential '${var.k8s-options.credential}'" : null,
    try(var.k8s-options.region, null) != null ? "--region '${var.k8s-options.region}'" : null,
    try(var.k8s-options.skip_storage, false) ? "--skip-storage" : null,
    try(var.k8s-options.storage, null) != null ? "--storage '${var.k8s-options.storage}'" : null,
  ])

  model_defaults_args = var.model_defaults != null ? compact([
    try(var.model_defaults.no_browser_login, false) ? "--no-browser-login" : null,
    try(var.model_defaults.file, null) != null ? "--file '${var.model_defaults.file}'" : null,
    try(var.model_defaults.ignore_read_only_fields, false) ? "--ignore-read-only-fields" : null,
    try(var.model_defaults.out_file, null) != null ? "--out-file '${var.model_defaults.out_file}'" : null,
    try(var.model_defaults.region, null) != null ? "--region '${var.model_defaults.region}'" : null,
    try(var.model_defaults.reset, null) != null ? "--reset '${var.model_defaults.reset}'" : null,
  ]) : []
}