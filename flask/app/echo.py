#!/usr/bin/env python

from flask import jsonify
from flask import Flask
from flask import request
import os
import logging

logger = logging.getLogger(__name__)


def setup_logging(verbose=False):
    '''
    Setup logging
    :param verbose: bool - Enable verbose debug mode
    '''

    ch = logging.StreamHandler()
    ch.setFormatter(logging.Formatter('[%(asctime)s] %(message)s'))
    logger.addHandler(ch)
    logger.setLevel(logging.INFO)
    if verbose:
        logger.setLevel(logging.DEBUG)


app = Flask(__name__)

setup_logging()


@app.route('/', defaults={'path': ''})

@app.route('/<path:path>')
def mock(path):
    logger.info("Handling request {0}".format(request.path))
    return jsonify(
        path=path,
        env=dict(**os.environ),
        request_args=dict(request.args),
        request_headers=dict(request.headers))


if __name__ == "__main__":
    app.run(host='0.0.0.0')
