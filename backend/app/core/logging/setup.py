from __future__ import annotations

import logging


def configure_logging(debug: bool) -> None:
    level = logging.DEBUG if debug else logging.INFO

    logging.basicConfig(
        level=level,
        format="%(levelname)s %(asctime)s %(name)s - %(message)s",
    )
