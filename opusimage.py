#!/usr/bin/env python3

from glob import glob
from mutagen.oggopus import OggOpus
from mutagen.flac import Picture
from base64 import b64encode

import argparse

parser = argparse.ArgumentParser(prog = "opusimage")
parser.add_argument("opusfile")
parser.add_argument("imagefile")

def add_image(audio_path, image_path):
    coverart = Picture()
    coverart.mime = "image/jpeg"
    with open(image_path, 'rb') as f:
        coverart.data = f.read()
    coverart.type = 3

    audio = OggOpus(audio_path)
    audio['metadata_block_picture'] = b64encode(coverart.write()).decode('ascii')

    audio.save()

def main():
    args = parser.parse_args()
    add_image(args.opusfile, args.imagefile)

if __name__ == "__main__":
    main()
