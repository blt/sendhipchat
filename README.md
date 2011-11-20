sendhipchat -- A sendmail like tool for [HipChat](http://hipchat.com)
=====================================================================

I do Ops for [CarePilot.com](https://www.carepilot.com) and we make
extensive use of [HipChat](http://hipchat.com) for planning and
coordination. Incongriously--and this is my fault--our notification is
done exclusively through email, mostly for want of a sendmail that
spits out to HipChat, rather than our local, friendly mail server.

`sendhipchat` fills that want. It's inspired by sendmail in all the
ways I care about and sends [room
messages](https://www.hipchat.com/docs/api/method/rooms/message).

Installation
------------

Assuming you have a Ruby environment setup (if you don't, I suggest
your system Ruby, [rbenv](https://github.com/sstephenson/rbenv) or
[RVM](http://beginrescueend.com/), in that order) then please:

    gem install sendhipchat

and enjoy.

Usage
-----

Send messages to a single room:

    echo 'single room message' | sendhipchat --api-token TOKEN --from 'sendhipchat' --rooms "SINGLE ROOM"

Send messages to multiple rooms:

    echo 'multiple room message' | sendhipchat --api-token TOKEN --from 'sendhipchat' --rooms "SINGLE ROOM","OTHER ROOM"

See the help text (`sendhipchat --help`) for more options.

Miscellania
-----------

`sendhipchat` has been developed as a part of my work with
[CarePilot](https://www.carepilot.com) and is released under the MIT
license. `sendhipchat` uses [semantic versioning](http://semver.org/).
