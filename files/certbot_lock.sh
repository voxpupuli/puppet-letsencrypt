# Managed by Puppet
LOCKFILE="/var/lock/certbot"
LOCKFD=99
# private
function _lock()          { flock "$@" $LOCKFD; }
function _release_lock()  { _lock -u; _lock -xn && rm -f $LOCKFILE; }
function _prepare_lock()  { eval "exec $LOCKFD>\"$LOCKFILE\""; trap _release_lock EXIT; }

# on start
_prepare_lock

# public
function exlock()         { _lock -x --timeout 30; }   # obtain an exclusive lock
function unlock()         { _lock -u; }                # drop a lock
