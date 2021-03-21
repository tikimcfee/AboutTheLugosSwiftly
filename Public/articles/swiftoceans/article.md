# If you want to use Swift with Linux, you should do it with:

* Ubuntu **18.04**
* Swift **5.2.0** - **5.2.4**
* Vapor **4.0.0**

# Because:

* NIO build errors somewhere in the stack with Ubuntu **20.04** and Swift **5.3.X**. I'm sure there are very good reasons why this is the case.

# Admittedly, I haven't tried:
* Using the 'official' docker image. I'd need to construct a Dockerfile to build the thing, and I have completely forgotten how to do that. But I suppose I should.

# I appreciate mergent.co:
* HaaS is rapidly evolving, and it serves as an example of a 'sweet spot' toolchain being the marker for functionality. Ironically, it's a prod-validation of the very toolchain it hosts.