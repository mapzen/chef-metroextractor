import requests, uritemplate

from csv import DictWriter
from os import SEEK_SET, SEEK_END
from io import BytesIO, TextIOWrapper
from argparse import ArgumentParser
from time import sleep, time
from os.path import join
from sys import stderr
import tarfile

PLACE_TYPES = 'region', 'locality', 'postalcode' #, 'neighbourhood'
WOF_URI = 'https://whosonfirst-api.dev.mapzen.com/{?method,extras,min_latitude,max_latitude,min_longitude,max_longitude}{&placetype,cursor}'
BASE_DIR = 'data'

parser = ArgumentParser(description='Tell us what they told you.')

parser.add_argument('bbox', type=float, nargs=4, metavar='deg.',
                    help='Bounding box degrees, given as (lon, lat, lon, lat).')

parser.add_argument('filename',
                    help='Output filename, should end in .tar.bz2.')

def main():
    args = parser.parse_args()
    return(bundle_wof(args.bbox, args.filename))

def bundle_wof(bbox, filename):
    '''
    '''
    # Prepare bundle file CSV.
    meta_buf = BytesIO()
    meta_txt = TextIOWrapper(meta_buf, encoding='utf8', write_through=True)
    meta_csv = DictWriter(meta_txt, ('placetype', 'id', 'name', 'parent_id', 'path'))
    meta_csv.writerow({f: f for f in meta_csv.fieldnames})
    
    # Start populating bundle tarball.
    with tarfile.open(filename, mode='w:bz2') as bundle_tar:
        for place in iterate_places(bbox):
            add_tar_place(bundle_tar, place['wof:path'], place['mz:uri'])
            
            row = {k: place['wof:{}'.format(k)] for k in meta_csv.fieldnames}
            meta_csv.writerow(row)
            
        add_tar_file(bundle_tar, 'index.csv', meta_buf)

def add_tar_place(tar_file, wof_path, mz_uri):
    ''' Download WoF place GeoJSON and add it to the tarball.
    '''
    got = get_url(mz_uri)
    
    if got.status_code != 200:
        raise Exception('Got status={}: {}'.format(got.status_code, got.text))
    
    geojson_data = BytesIO(got.content)
    geojson_path = join(BASE_DIR, wof_path)
    add_tar_file(tar_file, geojson_path, geojson_data)

def add_tar_file(tar_file, filename, buffer):
    ''' Add a file to the tarball with content from a buffer.
    '''
    tar_info = tarfile.TarInfo(filename)

    buffer.seek(0, SEEK_END)
    tar_info.size = buffer.tell()
    tar_info.mtime = time()

    buffer.seek(0, SEEK_SET)
    tar_file.addfile(tar_info, buffer)

def iterate_places(bbox):
    ''' Iterate over places.
    '''
    for placetype in PLACE_TYPES:
        for place in iterate_places_type(bbox, placetype):
            yield place

def iterate_places_type(bbox, placetype):
    ''' Iterate over places of a single type.
    '''
    lon1, lat1, lon2, lat2 = bbox
    
    query = {
        'method': 'whosonfirst.places.getIntersects',
        'min_latitude': min(lat1, lat2),
        'min_longitude': min(lon1, lon2),
        'max_latitude': max(lat1, lat2),
        'max_longitude': max(lon1, lon2),
        'extras': 'mz:uri,wof:path',
        'placetype': placetype,
        }
    
    while True:
        url = uritemplate.expand(WOF_URI, query)
        got = get_url(url)
        
        if got.status_code != 200:
            raise Exception('Got status={}: {}'.format(got.status_code, got.text))
    
        if got.json().get('stat') == 'ok':
            for result in got.json().get('results'):
                yield result
    
        if got.json().get('cursor', 0) == 0:
            break
            
        query.update(cursor=got.json().get('cursor', 0))

def get_url(url):
    ''' Get URL response while respecting rate-limit responses.
    '''
    for backoff in range(1, 99):
        got = requests.get(url)
        
        if got.status_code != 429:
            print('Got', url, file=stderr)
            return got

        print('Zzzz...', file=stderr)
        sleep(backoff)
