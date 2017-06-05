<?php

return [
    [
        false,
    ],
    [
        null,
        false,
    ],
    [
        -1,
        false,
    ],
    [
        0,
        false,
    ],
    [
        9,
        false,
    ],
    [
        1.5,
        false,
    ],
    [
        '',
        false,
    ],
    [
        '-1',
        false,
    ],
    [
        '2',
        false,
    ],
    [
        '-1.5',
        false,
    ],
    [
        'ABC',
        false,
    ],
    [
        '#VALUE!',
        true,
    ],
    [
        '#N/A',
        true,
    ],
    [
        'TRUE',
        false,
    ],
    [
        true,
        false,
    ],
    [
        false,
        false,
    ],
];
