#!/bin/sh
# Managed by Puppet
LOCKFILE="/var/lock/certbot"
LOCKFD=9
# private
_lock() {
  local lock_binary=$(which flock)
  if [ -z "${lock_binary}" ]; then
    lock_binary=$(which lockf)
    if [ -z "${lock_binary}" ]; then
      echo "flock/lockf binary wasn't found"
      exit 1
    fi
  fi
  ${lock_binary} "$@" $LOCKFD;
}
_release_lock()  { _lock -u; _lock -xn && rm -f $LOCKFILE; }
_prepare_lock()  { eval "exec $LOCKFD>\"$LOCKFILE\""; trap _release_lock EXIT; }

# on start
_prepare_lock

# public
exlock()         { _lock -x --timeout 30; }   # obtain an exclusive lock
unlock()         { _lock -u; }                # drop a lock
