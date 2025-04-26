import os
import sys
import requests
from urllib.parse import urlparse

def download_http(url, local_path):
    """Download a file from an HTTP/HTTPS URL and save it locally."""
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(local_path, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        return local_path
    else:
        print(f"Failed to download {url}: {response.status_code}", file=sys.stderr)
        return None

def url_wrapper(url, use_basedir=False):
    """Handles local and remote files (only HTTP now)."""
    if use_basedir:
        src_url = os.path.join(workflow.basedir, url)
    else:
        src_url = url

    if os.path.isfile(src_url):
        return src_url  # Local file
    else:
        o = urlparse(url)
        local_filename = os.path.basename(o.path)  # Extract filename
        local_path = os.path.join(os.getcwd(), "data", local_filename)  # Save to "data" folder

        if o.scheme in ('http', 'https'):
            return download_http(url, local_path)
        else:
            print(f'Invalid URL "{url}", returning input without transformation', file=sys.stderr)
            return url


