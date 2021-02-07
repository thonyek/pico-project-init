# Pico Project Init

Raspberry pi pico microcontroller project creator script.
Creating a project for pico microcontroller made easy (kinda).

## Required stuff
1. Cmake
2. gcc-arm-none-eabi
3. libnewlib-arm-none-eabi
4. build-essential

Just run this command to install the above stuff.
```bash
sudo apt update
sudo apt install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential
```

## Installation

Clone this repo to your desired directory.

```bash
git clone https://github.com/thonyek/pico-project-init.git
```

## Usage

change the directory into pico-project-init and run the script.
```bash
cd pico-project-init
chmod +x build_pico.sh
./build_pico.sh <project_name>
```
This will pull the latest SDK from raspberry pi repos, create a project with your supplied name and build a sample blink binary file in the build folder which you can load into your pi pico microcontroller.

When you added a new source file in the src folder, just re-run this script again without supplying the project name to automagically indexing the new source files into the Cmake build script.
```bash
./build_pico.sh
```
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
GPL-3.0. Look, I don't really care, just do whatever you want with this. No warranty whatsoever!.
