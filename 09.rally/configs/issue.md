## keystone

- KeystoneBasic.create_and_delete_ec2credential(**create-and-delete-ec2credential.json**)
> skip ec2

## nova

- NovaServers.boot_and_associate_floating_ip
> Conflict: Multiple possible networks found, use a Network ID to be more specific.

- NovaServers.boot_and_live_migrate_server
> Error BadRequest: overcloud-compute-0.localdomain is not on local storage: Block migration can not be used with shared storage.

- NovaKeypair.boot_and_delete_server_with_keypair
> Error Conflict: Multiple possible networks found, use a Network ID to be more specific.

- NovaSecGroup.boot_and_delete_server_with_secgroups
> Error Forbidden: Quota exceeded for resources: ['security_group'].

## neutron

- NeutronLoadbalancerV1.create_and_delete_healthmonitors
> Invalid scenario argument: 'Neutron extension lbaas is not configured'`

- NeutronLoadbalancerV1.create_and_delete_pools
> Invalid scenario argument: 'Neutron extension lbaas is not configured'`

- NeutronLoadbalancerV1.create_and_delete_vips
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