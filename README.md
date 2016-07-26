# Example for mesos slave URI fetcher failures.

1.  `nixops create -d fetcher-fail master ./machines.nix`
2. `bash mesos_job_no_archive.sh` -> should work
2. `bash mesos_job_with_tgz_uri.sh` -> fails.
    Example output:
    ```
$ bash mesos_job_with_tgz_uri.sh 
#### Add app with tar_file.tgz URI
{"id":"/tar-gz","cmd":"find; while true; do date; sleep 30; done","args":null,"user":null,"env":{},"instances":1,"cpus":0.1,"mem":10,"disk":0,"executor":"","constraints":[],"uris":["http://master/tar_file.tgz"],"fetch":[{"uri":"http://master/tar_file.tgz","extract":true,"executable":false,"cache":false}],"storeUrls":[],"ports":[0],"requirePorts":false,"backoffSeconds":1,"backoffFactor":1.15,"maxLaunchDelaySeconds":3600,"container":null,"healthChecks":[],"dependencies":[],"upgradeStrategy":{"minimumHealthCapacity":1,"maximumOverCapacity":1},"labels":{},"acceptedResourceRoles":null,"ipAddress":null,"version":"2016-07-26T08:39:49.316Z","tasksStaged":0,"tasksRunning":0,"tasksHealthy":0,"tasksUnhealthy":0,"deployments":[{"id":"525be742-056c-44bf-884c-022f746bb60b"}],"tasks":[]}
### Waiting until the app is ready
task id: "tar-gz.89973600-530c-11e6-9dfe-08002760929b"
#### Delete app again
{"version":"2016-07-26T08:40:05.396Z","deploymentId":"0e0dd704-4098-4682-bdfa-54db05144e73"}#### Check logs
I0726 08:39:59.619226  3487 fetcher.cpp:424] Fetcher Info: {"cache_directory":"\/tmp\/mesos\/fetch\/slaves\/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-S0","items":[{"action":"BYPASS_CACHE","uri":{"cache":false,"executable":false,"extract":true,"value":"http:\/\/master\/tar_file.tgz"}}],"sandbox_directory":"\/var\/lib\/mesos\/slave\/slaves\/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-S0\/frameworks\/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-0000\/executors\/tar-gz.89973600-530c-11e6-9dfe-08002760929b\/runs\/b5109c6e-4288-46bd-8fd0-8ae7010c24d0"}
I0726 08:39:59.622468  3487 fetcher.cpp:379] Fetching URI 'http://master/tar_file.tgz'
I0726 08:39:59.622506  3487 fetcher.cpp:250] Fetching directly into the sandbox directory
I0726 08:39:59.622561  3487 fetcher.cpp:187] Fetching URI 'http://master/tar_file.tgz'
I0726 08:39:59.622588  3487 fetcher.cpp:134] Downloading resource from 'http://master/tar_file.tgz' to '/var/lib/mesos/slave/slaves/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-S0/frameworks/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-0000/executors/tar-gz.89973600-530c-11e6-9dfe-08002760929b/runs/b5109c6e-4288-46bd-8fd0-8ae7010c24d0/tar_file.tgz'
I0726 08:39:59.687685  3487 fetcher.cpp:84] Extracting with command: /nix/store/3wd1y5bjl4xzhwwd5z3dy7153w5mfmyr-gnutar-1.29/bin/tar -C '/var/lib/mesos/slave/slaves/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-S0/frameworks/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-0000/executors/tar-gz.89973600-530c-11e6-9dfe-08002760929b/runs/b5109c6e-4288-46bd-8fd0-8ae7010c24d0' -xf '/var/lib/mesos/slave/slaves/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-S0/frameworks/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-0000/executors/tar-gz.89973600-530c-11e6-9dfe-08002760929b/runs/b5109c6e-4288-46bd-8fd0-8ae7010c24d0/tar_file.tgz'
Failed to fetch 'http://master/tar_file.tgz': Failed to extract: command /nix/store/3wd1y5bjl4xzhwwd5z3dy7153w5mfmyr-gnutar-1.29/bin/tar -C '/var/lib/mesos/slave/slaves/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-S0/frameworks/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-0000/executors/tar-gz.89973600-530c-11e6-9dfe-08002760929b/runs/b5109c6e-4288-46bd-8fd0-8ae7010c24d0' -xf '/var/lib/mesos/slave/slaves/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-S0/frameworks/bfa84ebc-18a1-443e-8ae5-50a5253c7bf4-0000/executors/tar-gz.89973600-530c-11e6-9dfe-08002760929b/runs/b5109c6e-4288-46bd-8fd0-8ae7010c24d0/tar_file.tgz' exited with status: 32512
Failed to synchronize with slave (it's probably exited)
```
