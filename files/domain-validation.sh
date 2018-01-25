#!/bin/sh
# THIS FILE IS MANAGED BY PUPPET

# First parameter is the certificate path
# All other parameters are the domain names requested for the certificate
# Split whitespace into newlines to let it play nicely with sort
certpath="${1}"
shift
domains=$(echo "${@}" | tr ' ' '\n')

# If certpath doesn't exist, run the exec
if ! test -f "${certpath}"; then
  exit 1
fi

# Get all subject alternative names from the certificate
certdomains=$(openssl x509 -in "${certpath}" -text -noout | grep -oP 'DNS:[^\s,]*' | sed 's/^DNS://g;')

# Sort and uniq all domains. Drop all Domains which occure twice
result=$(printf '%s\n%s' "${certdomains}" "${domains}" | sort | uniq -c | grep -Pcv '^[ \t]*2[ \t]')

# If all requested domains are already in the certificate, the $result will be 0 otherwise > 0
if [ "${result}" -eq 0 ]; then
  exit 0
else
  exit 1
fi
