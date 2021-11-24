FROM aescobaricc/base-odoo:0.0.1

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf
ENV ODOO_CONFIGURATION_FILE=/etc/odoo/odoo.conf
ENV ODOO_GROUP="odoo"
ENV ODOO_USER="odoo"
ENV ODOO_DATA_DIR=/var/lib/odoo
ENV ODOO_LOG_DIR=/var/log/odoo

ENV PGHOST 172.20.5.1
ENV PGPORT 5432
ENV PGDB odoo_db
ENV PGUSER odoo
ENV PGPASSWORD password

WORKDIR /odoo
#COPY ./ /odoo/
COPY ./debian/odoo.conf /etc/odoo/

RUN adduser --system --home $ODOO_DATA_DIR --quiet --group $ODOO_USER
RUN chown $ODOO_USER /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

# Expose Odoo services
EXPOSE 8069 8071 8072

#ENTRYPOINT ./odoo-bin --addons-path="addons/" -d rd-demo
#ENTRYPOINT python run_infinity.py
ENTRYPOINT gunicorn odoo.service.wsgi_server:application -c /odoo/odoo/service/wsgi_server_conf.py