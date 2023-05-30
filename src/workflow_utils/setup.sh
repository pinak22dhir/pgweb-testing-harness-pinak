# Settings for settings_local.py
conf='DEBUG=True\nSITE_ROOT="http://localhost:8000"\nSESSION_COOKIE_SECURE=False\nSESSION_COOKIE_DOMAIN=None\nCSRF_COOKIE_SECURE=False\nCSRF_COOKIE_DOMAIN=None\nALLOWED_HOSTS=["*"]'
database="DATABASES = {\n\t'default': {\n\t\t'ENGINE': 'django.db.backends.postgresql_psycopg2',\n\t\t'NAME': 'pgs',\n\t\t'PORT': 5432,\n\t\t'PASSWORD': 'postgres',\n\t\t'HOST' : 'localhost',\n\t\t'USER': 'postgres'\n\t}\n}"

# ------------------------------

# Clone PGWeb repository
git clone git://git.postgresql.org/git/pgweb.git
cd pgweb

# Build System dependencies
sudo apt update && sudo apt-get install -y postgresql-client python3-pip firefox libnss3

pg_isready --host=localhost

# Python dependencies
pip install -r requirements.txt
pip install -r ../../../requirements.txt

# Create Database
psql -h localhost -U postgres -c "CREATE DATABASE pgs;"

# Add Local Settings
touch pgweb/settings_local.py
echo -e $conf >>pgweb/settings_local.py
echo -e $database >>pgweb/settings_local.py
cat pgweb/settings_local.py

# Migrations
./manage.py migrate

# Test scripts
# psql -d pgweb -f sql/varnish_local.sql

functional_tests = ../../functional_tests

for entry in ../../functional_tests/*; do
	echo "$entry"
	cp "$entry" pgweb/
done

# Run all the tests
python manage.py test --pattern="tests_*.py" # --liveserver localhost:8081
