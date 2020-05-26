- [Instalar en Linux](#instalar-en-linux)
  * [En el cliente Windows](#en-el-cliente-windows)
  * [En Ansible Master](#en-ansible-master)

# Instalar en Linux
## En Ansible Master
* https://blog.deiser.com/es/primeros-pasos-con-ansible

* Ejemplo de inventario:
<pre>
[root@ansible ansible_windows]# cat ansible.cfg
[defaults]
roles_path    = /etc/ansible/roles:/usr/share/ansible/roles
inventory     = ./hosts
[privilege_escalation]
[paramiko_connection]
[ssh_connection]
[persistent_connection]
[accelerate]
[selinux]
[colors]
[diff]
[root@ansible ansible_windows]# 
</pre>

* Variables a nivel de inventario:
  * https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
<pre>
group_vars
host_Vars

mkdir group_vars
cd group_vars
ansible-vault create nodes.yml

ansible-vault edit nodes.yml 
ansible_ssh_user: rlujan
ansible_ssh_pass: rlujan
ansible_ssh_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
</pre>

* Ansible  modules: https://docs.ansible.com/ansible/latest/modules/modules_by_category.html
 * **Online:** https://docs.ansible.com/ansible/latest/modules/service_module.html#service-module
 * **On server:** ansible-doc service

* Si tuviéramos encriptado las variables:
<pre>
ansible -m win_ping windows --ask-vault-pass
</pre>

* Facters:
<pre>
ansible -m setup nodes
</pre>

* Ejecutar modulos Ad-hoc
<pre>
ansible -m service -a "name=crond state=stopped" centos
ansible -m service -a "name=crond state=stopped" centos -b
ansible -m service -a "name=crond state=started" centos -b
</pre>

* Playbooks:
<pre>
[renzo@ansible ansible_demo]$ pwd
/etc/ansible_demo
[renzo@ansible ansible_demo]$ ls -l ansible.cfg hosts
-rw-r--r-- 1 root root 184 May 24 01:03 ansible.cfg
-rw-r--r-- 1 root root  14 May 21 12:30 hosts
[renzo@ansible ansible_demo]$ 

ansible-playbook playbooks/demo.yml --check
ansible-playbook playbooks/demo.yml 
</pre>

* Roles:
<pre>
ansible-galaxy init apache
</pre>

* Componentes de un rol:
  * **defaults**: Data sobre el rol / aplicación (variables por defecto).
  * **files**: Poner ficheros estáticos aquí. Ficheros que copiaremos a los clientes.
  * **handlers**: Tareas que se basan en algunas acciones. Disparadores (Triggers). Ex: si cambias httpd.conf -> reinicia el servicio.
  * **meta**: Metadatos/Información sobre el rol (Autor, plataformas soportadas, dependencias, etc).
  * **tasks**: Core lógico o código. Ex: Instala paquetes, copia ficheros, configura, etc.
  * **templates**: similar a files pero soportan modificaciones (ficheros dinámicos no estáticos) -> Jinja2 template language.
  * **vars**: Tanto vars como defaults guardan variables pero las variables en vars tienen mayor prioridad.
  * Todos tienen el main.yml que es donde inicia la lectura de cada código.

* En cliente windows para ver usuarios:
<pre>
Server Manager -> Tools -> Computer Management -> Local Users and Groups -> Users
</pre>

* Rol run:
<pre>
ansible-playbook masterplaybooks/win_apache.yml --extra-vars="hosts=windows" --tags=notepad --check
ansible-playbook masterplaybooks/win_apache.yml --extra-vars="hosts=windows" --tags=notepad

ansible-playbook masterplaybooks/win_apache.yml --extra-vars="hosts=windows"
</pre>

* En cmd:
<pre>
C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin>httpd.exe -v
Server version: Apache/2.2.25 (Win32)
Server built:   Jul 10 2013 01:52:12

C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin>

"C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin\httpd.exe" -k stop
"C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin\httpd.exe" -k uninstall
del "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\htdocs\index.html"
</pre>

* Probar que funciona, abrir navegador:
<pre>
http://localhost/
</pre>

* Más Ejemplos:
  * https://geekflare.com/ansible-playbook-windows-example/
