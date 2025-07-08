#!/usr/bin/env python3
# chromadb-server.py
# Requirements: chromadb>=0.4.0, uvicorn[standard], duckdb, pyarrow,
#               opentelemetry-api, opentelemetry-sdk, opentelemetry-instrumentation-fastapi

import os
import sys
import logging
import shutil
import subprocess


def setup_logging():
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    # Reduce verbosity of dependencies
    logging.getLogger("uvicorn").setLevel(logging.WARNING)
    logging.getLogger("chroma").setLevel(logging.WARNING)


def ensure_data_path(path: str):
    try:
        if not os.path.isdir(path):
            logging.info(f"Data directory '{path}' not found. Creating it.")
            os.makedirs(path, exist_ok=True)
        else:
            logging.info(f"Using existing data directory '{path}'.")
    except Exception as e:
        logging.error(f"Could not create data directory '{path}': {e}")
        sys.exit(1)


def ensure_chroma_cli():
    chroma_cmd = shutil.which("chroma")
    if chroma_cmd is None:
        logging.error(
            "Chroma CLI not found. Make sure you have 'chromadb' installed:"
            " pip install chromadb uvicorn[standard] duckdb pyarrow"
        )
        sys.exit(1)
    logging.info(f"Found Chroma CLI at {chroma_cmd}")


if __name__ == "__main__":
    setup_logging()

    # Environment overrides
    host = os.getenv("CHROMA_HOST", "0.0.0.0")
    port = os.getenv("CHROMA_PORT", "8085")
    data_path = os.getenv(
        "CHROMA_PERSIST_DIRECTORY",
        os.path.abspath(os.path.join(os.path.dirname(__file__), "chroma_data"))
    )

    ensure_data_path(data_path)
    ensure_chroma_cli()

    cmd = [
        "chroma",
        "run",
        "--host", host,
        "--port", port,
        "--path", data_path,
    ]

    logging.info(f"Starting ChromaDB server with CLI: {' '.join(cmd)}")
    try:
        # This call will block until the server exits
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"ChromaDB server exited with return code {e.returncode}")
        sys.exit(e.returncode)
    except Exception:
        logging.exception("Failed to launch ChromaDB server via CLI")
        sys.exit(1)
