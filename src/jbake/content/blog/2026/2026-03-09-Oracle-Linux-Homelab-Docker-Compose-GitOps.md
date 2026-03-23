title=A quick tour of my new Homelab
date=2026-03-09
type=post
tags=linux,docker
status=draft
~~~~~~

Disclaimer: I really tried to write this with AI but the slop was too much. So I hope you enjoy it!

I've been on the self-hosting trend for a couple of years, mostly running Raspberry Pis 24/7 in my network. Why? ... as a 90's kid **I've hoarded a lot of music, videos, films and photos that I prefer to host myself** due space (> 2TB), privacy and cost.

In this line, my procedure to self host was like this over the years:

1. Buy a low powered device capable of running 24/7 without breaking the bank
2. Install a Debian based distro (which is common on the Pi community)
3. Connect via USB one big SSD
4. Bootstrap services here and there with apt and config files wrangling, services like
    a. MiniDLNA
    b. SMB Server
    c. Nextcloud
    d. Pi-hole
    e. Tailscale

**This was enough for a couple of years and I lived the transition Pi 2 -> Pi 3 -> Pi 4**. However, the Pi 4 was was a breaking point.

Altough I like the case I chose for it (the Nespi case) most of the times **I ended up buying some kind of fan because CPU gets really hot, and, these broke once per semester and/or made a lot of noise**. The Pi was the obvius choise because of the power vs. energy vs. price balance these oferred. [However the balance got lost with the Pi 5](https://www.raspberrypi.com/news/more-memory-driven-price-rises/).

## From ARM to x86_64

As a *self-hoster*, I was quite aware of a trend in the community surrounding the Intel N100, which finally delivered a capable and energy efficient x86_64 processor. So, as the time passed, it became the obvious choice as I didn't really use the GPIO pins from the Raspi, I'm far from a maker.

All and all, I took a brief detour from my family vacations and went to Paraguay, which is [the biggest electronic market in LATAM](https://es.wikipedia.org/wiki/Ciudad_del_Este), to get a cheap and lovelly N150 machine capable enough running my homelab, specifically a Blackview MP60.

This little machine included:

1. 16 GB of RAM
2. A NVME SSD with 512 GB
3. A SSD cady where I attached a 2.5" 2 TB SSD
4. A couple of USB-3 ports
5. Surprisingly a low noise fan

And I added

1. A main 2 TB storage 2.5" SSD inside the caddy. **A RAW space directly attached to my Oracle Linux VM**
2. A backup 512 GB storage 2.5" SSD using a external caddy. **This to isolate my backups**.

## Approaching the server as a software engineer

On my daily job I do tons of DevOps stuff but I never tried to approach the homelab like IaC, however, it was time to get serius. I took some design choices and landed the following abstraction layers:

* **Level -1**: The MP60 machine
* **Level 0**: A hypervisor with proxmox. Which among other things allows KVM virtual machines, LXC containers and is giving a good fight to other virtualization platforms. 
* **Level 1.a**: *The Docker House*. As [suggested by proxmox](), whenever you run Docker containers it is preferred to run these inside a VM host. For this I chose Oracle Linux 10, which is free to use, particularly stable and a well know [Enterprise Linux]() supporter
* **Level 1.b**: *The Tailscale Tunnel*. I ran a different "host" to create a Tailscale exit node. Whenever I'm on the road and wanna hit something on my homeserver. I turn on the Tailscale network and I'm able to reach my home network, and then, this little container is the exit port for me *to be* in Brazil inside my home network. I deploed this with Oracle Linux 9 and LXC containers
* **Level 1.c**: *The Kopia storage*. A Rocky Linux 10 LXC container, running nothing. Just a pure SSH server to isolate the access to the external SSD
* **Level 2**: Inside the Docker House. I run my services using Docker Compose files




## Docker vs. LXC vs. VM

Since I mostly do 


## Final thoughts

The full source is at [github.com/tuxtor/oracle-linux-docker-0-compose-stacks](https://github.com/tuxtor/oracle-linux-docker-0-compose-stacks). I think the main value of this setup isn't any individual service — it's the discipline of treating homelab infrastructure as code. If the machine dies tomorrow, I push to a new box and everything comes back. I really hope this is useful if you're thinking about doing something similar.
