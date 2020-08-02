import os
from notebook.auth import passwd

c = get_config()
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.password = passwd(os.environ['JUPYTER_PASSWD'])
c.NotebookApp.notebook_dir = os.environ['JUPYTER_WORKING_DIR']
