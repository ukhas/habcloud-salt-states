#!/bin/bash
set -o errexit -o nounset -o pipefail
set -x

sudo -Hu postgres psql -e -v ON_ERROR_STOP=1 tawhiri <<EOF
CREATE TABLE predictions (
    prediction_id SERIAL PRIMARY KEY,
    launch_latitude double NOT NULL,
    launch_longitude double NOT NULL,
    launch_altitude double NOT NULL,
    launch_datetime timestamp with time zone NOT NULL
);

GRANT INSERT ON predictions TO tawhiri;
GRANT SELECT, UPDATE on predictions_prediction_id_seq TO tawhiri;

GRANT SELECT ON predictions TO daniel;
GRANT SELECT ON predictions TO adam;
EOF

touch /srv/tawhiri/.created-predictions-table
