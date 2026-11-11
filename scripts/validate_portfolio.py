#!/usr/bin/env python3
"""Offline validation for the static legal-tech portfolio."""
from html.parser import HTMLParser
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"

class Inspector(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ids = set()
        self.refs = []
        self.errors = []
        self.mains = 0
        self.h1s = 0

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        id_ = a.get("id")
        if id_:
            if id_ in self.ids:
                self.errors.append("Duplicate id: " + id_)
            self.ids.add(id_)
        if tag == "main":
            self.mains += 1
        if tag == "h1":
            self.h1s += 1
        if tag == "img" and "alt" not in a:
            self.errors.append("Image without alt")
        for key in ("src", "href"):
            if a.get(key):
                self.refs.append(a[key])

def main():
    inspector = Inspector()
    inspector.feed((DOCS / "index.html").read_text(encoding="utf8"))
    errors = list(inspector.errors)
    for ref in inspector.refs:
        if ref.startswith("#"):
            if ref[1:] and ref[1:] not in inspector.ids:
                errors.append("Broken anchor: " + ref)
            continue
        if ref.startswith(("https://", "http://", "mailto:", "tel:")):
            continue
        target = ref.split("?")[0].split("#")[0]
        if not (DOCS / target).is_file():
            errors.append("Missing asset: " + target)
    if inspector.mains != 1 or inspector.h1s != 1:
        errors.append("Expected one main landmark and one h1")
    css = (DOCS / "style.css").read_text(encoding="utf8")
    js = (DOCS / "app.js").read_text(encoding="utf8")
    if "prefers-reduced-motion" not in css:
        errors.append("Missing reduced motion")
    if "aria-pressed" not in js:
        errors.append("Missing accessible filter state")
    for file in [DOCS / "favicon.svg", *(ROOT / "assets").glob("*.svg")]:
        try:
            ET.parse(file)
        except ET.ParseError as exc:
            errors.append(str(file) + ": " + str(exc))
    if errors:
        for message in errors:
            print("ERROR:", message, file=sys.stderr)
        return 1
    print("Portfolio static checks passed.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
