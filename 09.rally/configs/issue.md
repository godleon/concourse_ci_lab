## keystone

- KeystoneBasic.create_and_delete_ec2credential(**create-and-delete-ec2credential.json**)
> 會發生一些 Error, 但測試結果是成功的

## nova

- NovaKeypair.boot_and_delete_server_with_keypair
> Error Conflict: Multiple possible networks found, use a Network ID to be more specific.

- NovaSecGroup.boot_and_delete_server_with_secgroups
> Error Forbidden: Quota exceeded for resources: ['security_group'].


- NovaServers.boot_and_get_console_output
> 跑多一點 workload 就會出現 **No valid host was found. There are not enough hosts available.**

- NovaServers.boot_and_show_server 
> 跑多一點 workload 就會出現 **No valid host was found. There are not enough hosts available.**

- NovaServers.boot_and_update_server
> 跑多一點 workload 就會出現 **No valid host was found. There are not enough hosts available.**

- NovaServers.boot_server_from_volume
> 跑多一點 workload 就會出現 **No valid host was found. There are not enough hosts available.**

NovaServers.boot_server_associate_and_dissociate_floating_ip 
> 跑多一點 workload 就會出現 **No more IP addresses available on network**


## neutron

- NeutronLoadbalancerV1.create_and_delete_healthmonitors (**create-and-delete-healthmonitors.json**)
> Invalid scenario argument: 'Neutron extension lbaas is not configured'`

- NeutronLoadbalancerV1.create_and_delete_pools (**create-and-delete-pools.json**)
> Invalid scenario argument: 'Neutron extension lbaas is not configured'`

- NeutronLoadbalancerV1.create_and_delete_vips (**create-and-delete-vips.json**)
> Invalid scenario argument: 'Neutron extension lbaas is not configured'`

- NeutronLoadbalancerV1.create_and_list_pools (**create-and-list-pools.json**)
> Invalid scenario argument: 'Neutron extension lbaas is not configured'`





```json
Failed validating 'additionalProperties' in schema:
    {'$schema': 'http://json-schema.org/draft-04/schema',
     'additionalProperties': False,
     'properties': {'cinder': {'additionalProperties': False,
                               'properties': {'gigabytes': {'minimum': -1,
                                                            'type': 'integer'},
                                              'snapshots': {'minimum': -1,
                                                            'type': 'integer'},
                                              'volumes': {'minimum': -1,
                                                          'type': 'integer'}},
                               'type': 'object'},
                    'designate': {'additionalProperties': False,
                                  'properties': {'domain_records': {'minimum': 1,
                                                                    'type': 'integer'},
                                                 'domain_recordsets': {'minimum': 1,
                                                                       'type': 'integer'},
                                                 'domains': {'minimum': 1,
                                                             'type': 'integer'},
                                                 'recordset_records': {'minimum': 1,
                                                                       'type': 'integer'}},
                                  'type': 'object'},
                    'manila': {'additionalProperties': False,
                               'properties': {'gigabytes': {'minimum': -1,
                                                            'type': 'integer'},
                                              'share_networks': {'minimum': -1,
                                                                 'type': 'integer'},
                                              'shares': {'minimum': -1,
                                                         'type': 'integer'},
                                              'snapshot_gigabytes': {'minimum': -1,
                                                                     'type': 'integer'},
                                              'snapshots': {'minimum': -1,
                                                            'type': 'integer'}},
                               'type': 'object'},
                    'neutron': {'additionalProperties': False,
                                'properties': {'floatingip': {'minimum': -1,
                                                              'type': 'integer'},
                                               'health_monitor': {'minimum': -1,
                                                                  'type': 'integer'},
                                               'network': {'minimum': -1,
                                                           'type': 'integer'},
                                               'pool': {'minimum': -1,
                                                        'type': 'integer'},
                                               'port': {'minimum': -1,
                                                        'type': 'integer'},
                                               'router': {'minimum': -1,
                                                          'type': 'integer'},
                                               'security_group': {'minimum': -1,
                                                                  'type': 'integer'},
                                               'security_group_rule': {'minimum': -1,
                                                                       'type': 'integer'},
                                               'subnet': {'minimum': -1,
                                                          'type': 'integer'},
                                               'vip': {'minimum': -1,
                                                       'type': 'integer'}},
                                'type': 'object'},
                    'nova': {'additionalProperties': False,
                             'properties': {'cores': {'minimum': -1,
                                                      'type': 'integer'},
                                            'fixed_ips': {'minimum': -1,
                                                          'type': 'integer'},
                                            'floating_ips': {'minimum': -1,
                                                             'type': 'integer'},
                                            'injected_file_content_bytes': {'minimum': -1,
                                                                            'type': 'integer'},
                                            'injected_file_path_bytes': {'minimum': -1,
                                                                         'type': 'integer'},
                                            'injected_files': {'minimum': -1,
                                                               'type': 'integer'},
                                            'instances': {'minimum': -1,
                                                          'type': 'integer'},
                                            'key_pairs': {'minimum': -1,
                                                          'type': 'integer'},
                                            'metadata_items': {'minimum': -1,
                                                               'type': 'integer'},
                                            'ram': {'minimum': -1,
                                                    'type': 'integer'},
                                            'security_group_rules': {'minimum': -1,
                                                                     'type': 'integer'},
                                            'security_groups': {'minimum': -1,
                                                                'type': 'integer'},
                                            'server_group_members': {'minimum': -1,
                                                                     'type': 'integer'},
                                            'server_groups': {'minimum': -1,
                                                              'type': 'integer'}},
                             'type': 'object'}},
     'type': 'object'}
```



