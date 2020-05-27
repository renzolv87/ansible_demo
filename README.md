- [Linux](#linux)
  * [Instalar y configurar Ansible Master](#instalar-y-configurar-ansible-master)
  * [Variables a nivel de inventario](#variables-a-nivel-de-inventario)
  * [Ansible vault para encriptar y guardar información sensible](#ansible-vault-para-encriptar-y-guardar-información-sensible)
  * [Ansible Modules](#ansible-modules)
  * [Playbooks:](#playbooks)
  * [Roles:](#roles)

# Linux
## Instalar y configurar Ansible Master
* https://blog.deiser.com/es/primeros-pasos-con-ansible

* Ejemplo de inventario:
<pre>
[renzo@ansible ansible_demo]$ cat ansible.cfg
[defaults]
remote_user   = renzo 
roles_path    = ./roles
inventory     = ./hosts
[privilege_escalation]
[paramiko_connection]
[ssh_connection]
[persistent_connection]
[accelerate]
[selinux]
[colors]
[diff]
[renzo@ansible ansible_demo]$ 
</pre>

## Variables a nivel de inventario
  * https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
<pre>
group_vars
host_Vars
</pre>

## Ansible vault para encriptar y guardar información sensible
<pre>
ansible-vault create nodes.yml

ansible-vault edit nodes.yml 
ansible_ssh_user: rlujan
ansible_ssh_pass: rlujan
ansible_ssh_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
</pre>

## Ansible Modules
 * **Todos:** https://docs.ansible.com/ansible/latest/modules/modules_by_category.html
 * **Online:** https://docs.ansible.com/ansible/latest/modules/service_module.html#service-module
 * **On server:** ansible-doc service

* **Si he de lanzar modulos con yamls encriptados:**
<pre>
ansible -m win_ping windows --ask-vault-pass
</pre>

* **Facters:**
<pre>
ansible -m setup nodes
</pre>

* **Ejecutar modulos Ad-hoc:**
<pre>
ansible -m service -a "name=crond state=stopped" centos
ansible -m service -a "name=crond state=stopped" centos -b
ansible -m service -a "name=crond state=started" centos -b
</pre>

## Playbooks
<pre>
[renzo@ansible ansible_demo]$ pwd
/etc/ansible_demo
[renzo@ansible ansible_demo]$ ls -l ansible.cfg hosts
-rw-r--r-- 1 root root 184 May 24 01:03 ansible.cfg
-rw-r--r-- 1 root root  14 May 21 12:30 hosts
[renzo@ansible ansible_demo]$ 

ansible-playbook playbooks/motd.yml --check
ansible-playbook playbooks/motd.yml
</pre>

* **Idempotencia:** es la propiedad para realizar una acción determinada varias veces y aun así conseguir el mismo resultado que se obtendría si se realizase una sola vez.

## Roles
<pre>
ansible-galaxy init apache
</pre>

* **Componentes de un rol:**
  * **defaults**: Data sobre el rol / aplicación (variables por defecto).
  * **files**: Poner ficheros estáticos aquí. Ficheros que copiaremos a los clientes.
  * **handlers**: Tareas que se basan en algunas acciones. Disparadores (Triggers). Ex: si cambias httpd.conf -> reinicia el servicio. (https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#handlers-running-operations-on-change)
  * **meta**: Metadatos/Información sobre el rol (Autor, plataformas soportadas, dependencias, etc).
  * **tasks**: Core lógico o código. Ex: Instala paquetes, copia ficheros, configura, etc.
  * **templates**: similar a files pero soportan modificaciones (ficheros dinámicos no estáticos) -> Jinja2 template language.
  * **vars**: Tanto vars como defaults guardan variables pero las variables en vars tienen mayor prioridad.
  * Todos tienen el main.yml que es donde inicia la lectura de cada código.

* **Rol run:**
<pre>
ansible-playbook masterplaybooks/masterplaybook_apache.yml --extra-vars="hosts=centos" --tags=install --check 
ansible-playbook masterplaybooks/masterplaybook_apache.yml --extra-vars="hosts=centos" --tags=install

ansible-playbook masterplaybooks/masterplaybook_apache.yml --extra-vars="hosts=centos"
</pre>

* **Validar que funciona, abrir navegador:**
<pre>
http://localhost/
</pre>
