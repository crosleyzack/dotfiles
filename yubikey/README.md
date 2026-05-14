# <img height="30" width="30" src="https://cdn.simpleicons.org/yubico/white" style="vertical-align:middle"/> Yubikey

Tools for working with yubikeys

### reset.sh

Factory reset a yubikey completely

### Pins

Yubikeys have [multiple pins](https://support.yubico.com/s/article/Understanding-YubiKey-PINs). These can be reset with:

```
ykman [--device ########] fido access change-pin
# see https://developers.yubico.com/PGP/PGP_Walk-Through.html
ykman [--device ########] openpgp access change-pin
ykman [--device ########] openpgp access change-admin-pin
ykman [--device ########] openpgp access change-access-code
# see https://docs.yubico.com/yesdk/users-manual/application-piv/pin-puk-mgmt-key.html
ykman [--device ########] piv access change-pin
ykman [--device ########] piv access change-puk
ykman [--device ########] piv access change-management-key
```