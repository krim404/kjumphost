## YubiKey GPG SSH Container
A containerized environment for using YubiKey with GPG and SSH authentication, featuring a customized shell experience with ZSH and Powerlevel10k.

### Features
* YubiKey Support: Full GPG smartcard functionality for YubiKey devices
* SSH Authentication: Use YubiKey GPG keys as SSH keys
* Custom Shell: Pre-configured ZSH with Oh My Zsh and Powerlevel10k theme
* OpenSSH Server: Built-in SSH server for remote access
* Security Tools: Includes GnuPG2, scdaemon, and pinentry for secure key management


### Run in Kubernetes:

```
apiVersion: v1
kind: Secret
metadata:
  name: user-password
  namespace: default
type: Opaque
stringData:
  password: "yourpassword"
  name: "yourusername"
  ssh: "ssh-rsa AAAAx"
---

apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: kjumphost
  name: kjumphost
spec:
  revisionHistoryLimit: 0
  selector:
    matchLabels:
      app: kjumphost
  template:
    metadata:
      labels:
        app: kjumphost
    spec:
      containers:
        - image: kjumphost:latest
          imagePullPolicy: Always
          name: kjumphost
          securityContext:
            privileged: true
          env:
            - name: USER_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: user-password
                  key: password#
            - name: USER_NAME
              valueFrom:
                secretKeyRef:
                  name: user-password
                  key: name
            - name: USER_SSH
              valueFrom:
                secretKeyRef:
                  name: user-password
                  key: ssh
          volumeMounts:
            - name: dev-usb
              mountPath: /dev/bus/usb
            - name: usb-sys
              mountPath: /sys/bus/usb
            - name: devices-sys
              mountPath: /sys/devices
            - name: hidraw0
              mountPath: /dev/hidraw0
            - name: hidraw1
              mountPath: /dev/hidraw1
      restartPolicy: Always
      volumes:
        - name: dev-usb
          hostPath:
            path: /dev/bus/usb
            type: Directory
        - name: usb-sys
          hostPath:
            path: /sys/bus/usb
        - name: devices-sys
          hostPath:
            path: /sys/devices
        - name: hidraw0
          hostPath:
            path: /dev/hidraw0
        - name: hidraw1
          hostPath:
            path: /dev/hidraw1

```

### Environment Variables
USER_PASSWORD: Set the root user password  
USER_NAME: Set an alias name for the root user
USER_SSH: Set an ssh key for login

### Included

* ZSH with Oh My Zsh
* Powerlevel10k theme
* GnuPG2 suite
* OpenSSH server
* Vim (pre-configured)


### Notes

- Root login is enabled for SSH (customize as needed)
- Container runs with elevated privileges for USB access
- GPG agent is automatically restarted on shell startup
- Password authentication is enabled
