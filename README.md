# Demo

## Intro

Welcome everyone, my name is Erik Veld and I am a developer advocate at hashicorp.
Today I would like to talk about Nomad, and in particular some of the less highlighted sides of Nomad.

We very often talk about containers and cross cloud and other fancy features such as autoscaling, but I feel the most powerful feature of Nomad is often overlooked.
And that is the flexibility of Nomad and it's ability to run other workloads besides containers.

I will be showing you how to run workloads that you might have been running with a combination of various systems such as systemd, scripts or provisioners.
And instead how you can run those with Nomad, using one common workflow and without having to containerize all these workloads.

And at the end there will be some shiny new things to show you as well, so stay tuned.

Alright, there is a lot to see, so lets dive straight in!

1 java
2 ingress
3 docker
4 qemu
5 exec
6 custom
7 pack

## Outro

So lets look back at what we have done.
1 We created a minecraft server using the java driver, and ran the jar file directly.
2 We created an ingress gateway using just the network and service stanza in a nomad job.
3 Ofcourse we ran a container just for good measure.
4 We ran a virtual machine with the qemu driver, connected to it over consul service mesh, then ran commands against our minecraft server, running with a totally different driver.
5 We used the exec driver to run a golang binary on each of the client nodes with a system job.
6 And using a self built taskdriver, scheduled minecarts within minecraft.
7 Finally we used nomad-pack to schedule common used applications without having to write a job file at all.

To round off this presentation I'd like to finish with something someone said a really long time ago.
Which was this. Now my elvish is a bit rusty, but luckily some chap called Tolkien tried to translate it in the 30's.
He translated it as:

One ring to rule them all,
One ring to find them,
One ring to bring them all, and in the darkness bind them.

Now that was not far off, but I think what that Sauron fellar really meant was:

Nomad to run them all,
Consul to connect them,
Vault to secure them all, and with the secrets bind them.

By using Nomad, you can use one common workflow across different workload types.
You can connect them all the same way using consul and take advantage of features such as MTLS encryption, intentions, service discovery.
And if you need to secure your workloads, the integration with Vault gives you a common way to supply secrets to your applications.

So the next time you need to run an application, wether it is containerized or not, consider Nomad.
Nomad is a great way to simplify your operational infrastructure.

If you just want to run containers, great. Even if you are already running a different scheduler like kubernetes for those, then nomad is a great compliment for any non-containerized workloads you might have.
And by combining it with Consul, you get network security, routing and observability that extends across of your clusters, for instance allowing you to simply and securely route traffic from a kubernetes pod to a nomad workload.  
When it comes to secrets management, Vault gives you a consistent and secure approach to providing all kinds of secrets from simple api keys and x509 certificates, to dynamically creates secrets to all of your workloads.

Thank you.

* Spin up the environment.

```shell
shipyard run
```

* Set the nomad address.

```shell
eval $(echo "export NOMAD_ADDR=http://localhost:"$(docker port server.dev.nomad-cluster.shipyard.run | grep 4646 | awk '{sub(/0.0.0.0:/,""); print $3 }'))
echo $NOMAD_ADDR
```

Lets dive right in. Now I have already spun up an environment with nomad and consul.

* Check the nomad cluster.

```shell
nomad server members
nomad node status -allocs
```

We have 1 server node and 3 client nodes.

* Check the consul cluster.

```shell
consul members
```

And each of those also have a consul agent.

## Java

The first workload I would like to run is a Java jar. If I already have a machine with a JVM there is no need for me to containerize the application, because Nomad can just run the application directly and handle isolation and network plumbing for us.

Lets start off with an empty job file.
So I first need to pull in some artifacts for our workload.

* Add the artifacts.

This server.zip contains two jar files, one of them is the minecraft server and the other is a wrapper around it for mod support. This is the jar that we will be running in our workload.
Nomad will automatically pull the artifact in and extract it to the destination location.

The other 2 artifacts are the game world and some mods that we want on our server.

Minecraft will also need some configuration and for us to accept the eula.

* Add the templates.

Now lets add the configuration for the jar file and the jvm.

* Add the config.

Ok, that should be it. Lets run the job.

```shell
nomad run files/nomad_jobs/java.hcl
```

Lets make sure it is running.

```shell
nomad status minecraft
```

It seems to be running fine.. but you never really know until you test it, right?
Lets join the server..

Now because we are running the job within the service mesh using the sidecar service stanza, we will need to do some extra work to allow services from outside the mesh the reach them.

So in order to join the server from my computer I will need to add an ingress gateway though.

```shell
nomad run files/nomad_jobs/ingress.hcl
```

Ok with that in place, lets fire up minecraft. Ok, there is our server. Joining...
Cool, it seems to work. So java workload covered.

So now that we are here, why not just continue from here?
Lets see, where did I leave that block?

* Looks through boxes

There it is! Lets also grab this and that... We can put that down here.
So our nomad server is running at ... ok save.

* Clients and allocations show up.

There we go! There is our cluster and the minecraft server we are currently running on.

## QEMU

Now what shall we run next? How about a virtual machine using QEMU?
Lets start off with the empty job file again.

```shell
nomad run -output demo/qemu.hcl
```

* Run the job from within minecraft.

```shell
tce-load -wi curl

# curl -L -o rcon.tar.gz https://github.com/itzg/rcon-cli/releases/download/1.5.1/rcon-cli_1.5.1_linux_386.tar.gz
curl -L -o rcon.tar.gz tinyurl.com/rcon-cli
tar xzf rcon.tar.gz

./rcon-cli --host 10.0.2.2 --port 25575 --password hashicraft
```

## Exec

...

## Custom task driver

...

Now that Nic has ruined all the fun, lets head back over to the terminal and wrap this up.

## Pack

But before we do, I'd like to show a new project we have been working on which we call Nomad Pack.

...

list packs
show info of a pack
run pack (show dependency?) run loki first...says it needs grafana
run grafana pack
run loki pack

add datasource in grafana, show dashboard with logs from minecraft.

## Closing

many different workloads but all with a similar workflow and job file.
lotr quote
