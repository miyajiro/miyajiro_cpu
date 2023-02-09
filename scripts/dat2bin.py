import os
import argparse

bin_file_path = "test/flag/flag.bin"


def dat2bin(dat_file_path):
    bin_file_path = f'{os.path.splitext(dat_file_path)[0]}.bin'

    with open(dat_file_path) as f:
        lines = [line.strip() for line in f]

    with open(bin_file_path, 'wb') as f:
        for line in lines:
            instrucion = int(line, 2)
            f.write(instrucion.to_bytes(4, 'little'))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-d', '--dat_file_path', type=str, default=None, required=True,
        help='path to dat file.'
    )

    args = vars(parser.parse_args())

    dat2bin(dat_file_path=args['dat_file_path'])