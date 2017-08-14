<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit2eccee4accf0ee527805b65cf67720f6
{
    public static $prefixLengthsPsr4 = array (
        'B' => 
        array (
            'Box\\Spout\\' => 10,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Box\\Spout\\' => 
        array (
            0 => __DIR__ . '/..' . '/box/spout/src/Spout',
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit2eccee4accf0ee527805b65cf67720f6::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit2eccee4accf0ee527805b65cf67720f6::$prefixDirsPsr4;

        }, null, ClassLoader::class);
    }
}