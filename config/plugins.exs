use Mix.Config
# This file configures Annon's plugin system

config :annon_api, :plugins, [
  {:ssl, deps: [], features: [:modify_conn], module: Annon.Plugins.SSL, system?: true},
  {:cors, deps: [], features: [:modify_conn], module: Annon.Plugins.CORS},
  {:idempotency, deps: [:cors], features: [:modify_conn, :log_consistency], module: Annon.Plugins.Idempotency},
  {:logger, deps: [:idempotency, :monitoring], features: [], system?: true, module: Annon.Plugins.Logger},
  {:monitoring, deps: [:cors], features: [], system?: true, module: Annon.Plugins.Monitoring},
  {:ip_restriction, deps: [:logger], features: [:modify_conn], module: Annon.Plugins.IPRestriction},
  {:ua_restriction, deps: [:logger], features: [:modify_conn], module: Annon.Plugins.UARestriction},
  {:auth, deps: [:ip_restriction, :ua_restriction], features: [:modify_conn], module: Annon.Plugins.Auth},
  {:acl, deps: [:auth], features: [:modify_conn], module: Annon.Plugins.ACL},
  {:validator, deps: [:acl, :ip_restriction, :ua_restriction, :logger], features: [:decode_body, :modify_conn],
    module: Annon.Plugins.Validator},
  {:proxy, deps: [:validator, :logger, :acl], features: [:modify_conn], module: Annon.Plugins.Proxy}
]
