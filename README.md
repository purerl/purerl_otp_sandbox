purerl_otp_sandbox
=====

An OTP application integrating PureScript code.

This is a sandbox for different ways of integrating eg OTP behaviours and demonstrating a sample build process, file layout etc.

Dependencies
-----
The executables `psc-package` (any relatively recent version) and `purs` (the purerl compiler fork, 0.12+) must be present in the `PATH`.

The [`rebar3`](http://www.rebar3.org/) executable should be available to perform the build steps below.

Build
-----

    $ rebar3 compile

This will kick off a PureScript build via the `Makefile`. The `Makefile` encodes no dependency information, but because PureScript compiler builds are incremental, updated `.erl` files are generated only for changed modules, these updated `.erl` files are then available for the usual `rebar3` compile process.

An `ide` target is available to be used with editor integrations (for full builds), both this and the `purs ide` server will work just fine for the purerl backend as long as the right `purs` is in your path.

Commentary
-----
An alternative arrangement would place the PureScript project structure entirely under a subdirectory, leading to e.g. `ps/src` folder. I've chosen not to do that here on the basis that 1. the amount of additional top-level junk is actually minimal in this PureScript project and 2. this means that editor integration will "just work" with the project opened at the root level.
