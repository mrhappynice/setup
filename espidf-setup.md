# Setup ESP-IDF:
---


```bash
sudo apt-get install git wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0
```

```bash
mkdir -p ~/esp
cd ~/esp
git clone https://github.com/espressif/esp-idf.git
```

```bash
sudo apt install gcc-arm-linux-gnueabihf python3-dev
```

```bash
./install.sh esp32s3
```
or esp32, esp32xx

Set environement:
```bash
. $HOME/esp/esp-idf/export.sh
```

Hello World:
```bash
cd ~/esp/hello_world
idf.py set-target esp32
idf.py menuconfig
```

```bash
idf.py build
```

```bash
idf.py -p PORT flash
```
