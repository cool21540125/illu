import pytest
from pytest_mock import MockFixture, mock, mocker
from demo_mock.mock_sample import func1, func2


class TestMock:

    @pytest.mark.parametrize('para, expect', [
        (5, 50),
        (-5, 0),
    ])
    def test_func2(self, para, expect):
        assert func2(para) == expect

    def test_only_func2(self, mocker):
        mocker.patch(
            'mock_sample', 0
        )
        assert func2(5) == 25
