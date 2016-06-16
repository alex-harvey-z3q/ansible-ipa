# Ansible Role: IPA

Installs and configures Red Hat's IPA in a Master/Replica configuration.

## Requirements

This role requires the `alexharvey.bind` role.

## Role Variables

|Name|Default|Type|Description|
|----|----|-----------|-------|
|`ipa_role`|`master`|String|The IPA role, `master` or `replica` allowed.|
|`prepare_replica`|`false`|String|Whether or not to prepare a replica. Set to true in the master role when building a master-replica configuration.|
|`master`||String|The FQDN of the IPA master.|
|`replica`||String|The FQDN of the IPA replica.|
|`domain`||String|The IPA DNS domain, e.g. `example.com`.|
|`realm`||String|The IPA Kerberos realm, e.g. `EXAMPLE.COM`.|
|`admin_password`||String|The IPA admin password.|
|`ds_password`||String|The IPA directory server password.|

## Configuration example

### Master

```yaml
---
ipa_role: master
prepare_replica: true
master: ipa1.example.com
replica: ipa2.example.com
domain: example.com
realm: EXAMPLE.COM
admin_password: admin1234
ds_password: dspass12
```

### Replica

```yaml
---
ipa_role: master
master: ipa1.example.com
replica: ipa2.example.com
domain: example.com
realm: EXAMPLE.COM
admin_password: admin1234
ds_password: dspass12
```

## Example playbook

```yaml
---
- hosts: servers
  roles:
  - ansible-ipa
```

## License

MIT.

## Run the tests

This role includes Test Kitchen tests that demonstrate an IPA configuration with a Master, a Replica, a separate DNS and a client.

To run the tests:

Make sure you have the following prerequisites installed:

* VirtualBox
* Vagrant
* Ruby Gems
* Ruby (tested on 2.0.0p481).

```
$ gem install bundler
$ bundle install
```

To set up and test the DNS server:

```
$ bundle exec kitchen verify dns-centos-72
```

To then set up and test the master:

```
$ bundle exec kitchen verify master-centos-72
```

To then set up and test the replica:

```
$ bundle exec kitchen verify replica-centos-72
```

To then set up and test the client and integration:

```
$ bundle exec kitchen verify client-centos-72
```

Teardown:

```
$ bundle exec kitchen destroy 
```
