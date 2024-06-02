#!/usr/bin/env python3

from glob import glob
from mutagen.oggopus import OggOpus
from mutagen.flac import Picture
from base64 import b64encode

import argparse
import os

parser = argparse.ArgumentParser(prog = "tagopus")
parser.add_argument("opusfile")
parser.add_argument("--image")
parser.add_argument("--title")
parser.add_argument("--album")
parser.add_argument("--artist")
parser.add_argument("--remove", action="store_true")

def get_mime(ext):
    if ext == ".png":
        return "image/png"

    if ext == ".jpeg" or ext == ".jpg":
        return "image/jpeg"
    
    raise Exception("Unsupported ext: " + ext)

def add_image(audio: OggOpus, image_path):
    _, ext = os.path.splitext(image_path)

    coverart = Picture()
    coverart.mime = get_mime(ext)

    with open(image_path, 'rb') as f:
        coverart.data = f.read()
    coverart.type = 3

    audio['metadata_block_picture'] = b64encode(coverart.write()).decode('ascii')

def main():
    args = parser.parse_args()

    audio = OggOpus(args.opusfile)

    if args.remove:
        audio.delete()

    if args.image:
        add_image(audio, args.image)

    if args.title:
        audio['title'] = args.title

    if args.album:
        audio['album'] = args.album
        
    if args.artist:
        audio['artist'] = args.artist

    audio.save()

if __name__ == "__main__":
    main()
