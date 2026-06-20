#!/usr/bin/env python3
"""Convert a PDF to Markdown alongside it: foo.pdf -> foo.md

Packaged in this flake (pkgs/pdf2md). Deps (pymupdf4llm) come from a pinned,
isolated nix env, never the global env.
  iterate:  nix develop .#pdf2md   then  python pkgs/pdf2md/pdf2md.py FILE.pdf
  ship:     my-nixos-rebuild       (rebuilds the wrapper from this file)
"""
import sys
from pathlib import Path

import pymupdf4llm


def main():
    if len(sys.argv) != 2:
        sys.exit("usage: pdf2md FILE.pdf")
    pdf = Path(sys.argv[1])
    if pdf.suffix.lower() != ".pdf" or not pdf.is_file():
        sys.exit(f"not a pdf file: {pdf}")
    md = pdf.with_suffix(".md")
    md.write_text(pymupdf4llm.to_markdown(str(pdf)), encoding="utf-8")
    print(md)


if __name__ == "__main__":
    main()
