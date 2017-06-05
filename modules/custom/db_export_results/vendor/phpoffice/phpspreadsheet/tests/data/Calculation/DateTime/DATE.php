<?php

//  Year, Month, Day, Result, Comments

return [
    [
        18,
        11,
        11,
        6890,
    ],
    // Excel 1900 Calendar Base Date
    [
        1900,
        1,
        1,
        1,
    ],
    // Day before Excel mythical 1900 leap day
    [
        1900,
        2,
        28,
        59,
    ],
    // Excel mythical 1900 leap day
    [
        1900,
        2,
        29,
        60,
    ],
    // Day after Excel mythical 1900 leap day
    [
        1900,
        3,
        1,
        61,
    ],
    // Day after Excel mythical 1900 leap day
    [
        1901,
        12,
        13,
        713,
    ],
    // PHP 32-bit Earliest Date
    [
        1901,
        12,
        14,
        714,
    ],
    [
        1903,
        12,
        31,
        1461,
    ],
    // Excel 1904 Calendar Base Date
    [
        1904,
        1,
        1,
        1462,
    ],
    [
        1904,
        1,
        2,
        1463,
    ],
    [
        1960,
        12,
        19,
        22269,
    ],
    // PHP Base Date
    [
        1970,
        1,
        1,
        25569,
    ],
    [
        1982,
        12,
        7,
        30292,
    ],
    [
        2008,
        6,
        12,
        39611,
    ],
    // PHP 32-bit Latest Date
    [
        2038,
        1,
        19,
        50424,
    ],
    // Day after PHP 32-bit Latest Date
    [
        2038,
        1,
        20,
        50425,
    ],
    [
        2008,
        1,
        1,
        39448,
    ],
    [
        2008,
        1,
        null,
        39447,
    ],
    [
        2008,
        1,
        -1,
        39446,
    ],
    [
        2008,
        1,
        -30,
        39417,
    ],
    [
        2008,
        1,
        -31,
        39416,
    ],
    [
        2008,
        1,
        -365,
        39082,
    ],
    [
        2008,
        3,
        1,
        39508,
    ],
    [
        2008,
        3,
        null,
        39507,
    ],
    [
        2008,
        3,
        -1,
        39506,
    ],
    [
        2008,
        3,
        -365,
        39142,
    ],
    [
        2008,
        null,
        1,
        39417,
    ],
    [
        2008,
        -1,
        1,
        39387,
    ],
    [
        2008,
        -11,
        1,
        39083,
    ],
    [
        2008,
        -12,
        1,
        39052,
    ],
    [
        2008,
        -13,
        1,
        39022,
    ],
    [
        2008,
        -13,
        30,
        39051,
    ],
    [
        2008,
        -13,
        null,
        39021,
    ],
    [
        2008,
        -13,
        -30,
        38991,
    ],
    [
        2008,
        -13,
        -31,
        38990,
    ],
    [
        2008,
        13,
        1,
        39814,
    ],
    [
        2007,
        15,
        null,
        39507,
    ],
    [
        2008,
        26,
        1,
        40210,
    ],
    [
        2008,
        26,
        -10,
        40199,
    ],
    [
        2008,
        -26,
        61,
        38686,
    ],
    [
        2010,
        -15,
        -50,
        39641,
    ],
    [
        2010,
        -15,
        50,
        39741,
    ],
    [
        2010,
        15,
        -50,
        40552,
    ],
    [
        2010,
        15,
        50,
        40652,
    ],
    [
        2010,
        1.5,
        1,
        40179,
    ],
    [
        2010,
        1.5,
        0,
        40178,
    ],
    [
        2010,
        0,
        1.5,
        40148,
    ],
    [
        2010,
        1,
        1.5,
        40179,
    ],
    [
        2012,
        6,
        15,
        41075,
    ],
    [
        2012,
        6,
        null,
        41060,
    ],
    [
        2012,
        null,
        15,
        40892,
    ],
    [
        null,
        6,
        15,
        167,
    ],
    [
        10,
        6,
        15,
        3819,
    ],
    [
        10,
        null,
        null,
        3622,
    ],
    [
        null,
        10,
        null,
        274,
    ],
    [
        null,
        null,
        10,
        '#NUM!',
    ],
    [
        -20,
        null,
        null,
        '#NUM!',
    ],
    [
        -20,
        6,
        15,
        '#NUM!',
    ],
    // Excel Maximum Date
    [
        9999,
        12,
        31,
        2958465,
    ],
    // Exceeded Excel Maximum Date
    [
        10000,
        1,
        1,
        '#NUM!',
    ],
    [
        2008,
        8,
        10,
        39670,
    ],
    [
        2008,
        12,
        31,
        39813,
    ],
    [
        2008,
        8,
        32,
        39692,
    ],
    [
        2008,
        13,
        31,
        39844,
    ],
    [
        2009,
        1,
        0,
        39813,
    ],
    [
        2009,
        1,
        -1,
        39812,
    ],
    [
        2009,
        0,
        0,
        39782,
    ],
    [
        2009,
        0,
        -1,
        39781,
    ],
    [
        2009,
        -1,
        0,
        39752,
    ],
    [
        2009,
        -1,
        -1,
        39751,
    ],
    [
        2010,
        0,
        -1,
        40146,
    ],
    [
        2010,
        5,
        31,
        40329,
    ],
    // MS Excel will fail with a #VALUE return, but PhpSpreadsheet can parse this date
    [
        2010,
        1,
        '21st',
        40199,
    ],
    // MS Excel will fail with a #VALUE return, but PhpSpreadsheet can parse this date
    [
        2010,
        'March',
        '21st',
        40258,
    ],
    // MS Excel will fail with a #VALUE return, but PhpSpreadsheet can parse this date
    [
        2010,
        'March',
        21,
        40258,
    ],
    [
        'ABC',
        1,
        21,
        '#VALUE!',
    ],
    [
        2010,
        'DEF',
        21,
        '#VALUE!',
    ],
    [
        2010,
        3,
        'GHI',
        '#VALUE!',
    ],
];
