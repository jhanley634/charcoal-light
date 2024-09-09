import unittest
import warnings
from collections.abc import Generator
from time import time

import regex
from requests_cache import CachedSession

with warnings.catch_warnings():
    warnings.filterwarnings("ignore", category=DeprecationWarning)
    from findspam import city_list


def get_document(url: str, expire: int = 86_400) -> str:
    session = CachedSession(cache_name="/tmp/requests_cache", expire_after=expire)
    return str(session.get(url).text)


TOM_SAWYER = 'https://www.gutenberg.org/cache/epub/74/pg74-images.html'


def get_novel(url: str = TOM_SAWYER) -> str:
    return get_document(url)


class TestNamedList(unittest.TestCase):
    def test_named_list_performance(self) -> None:
        self.assertEqual(142, len(city_list))
        brackets_re = regex.compile(r"\[(\L<city>)\]", city=city_list)
        self.assertIsNone(brackets_re.search("He lives in Lahore, Pakistan."))
        self.assertEqual(535_609, len(get_novel()))

        def get_times() -> Generator[float, None, None]:
            for _ in range(6):
                t0 = time()
                m = brackets_re.search(lahore)
                yield round(time() - t0, 4)
                assert m
                self.assertEqual("Lahore", m[1])

        lahore = get_novel() + "He lives in [Lahore], Pakistan."
        print('\n', sorted(get_times()))
