import pytest
from test_spam_examples import spam_examples, tst_findspam2


@pytest.mark.parametrize(
    "title, body, username, site, body_is_summary, is_answer, expected_spam",
    sorted(spam_examples),
)
def test_spam_examples(title: str, body: str, username: str, site: str, body_is_summary: bool, is_answer: bool, expected_spam: bool) -> None:
    print('\n', title)
    tst_findspam2(title, body, username, site, body_is_summary, is_answer, expected_spam)
