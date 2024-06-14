<?php

if (!file_exists(__DIR__.'/src')) {
    exit(0);
}

return (new PhpCsFixer\Config())
    ->setRules([
        '@PHP71Migration' => true,
        '@PHPUnit75Migration:risky' => true,
        '@Symfony' => true,
        '@Symfony:risky' => true,
        'protected_to_private' => false,
        'header_comment' => ['header' => ''],
        'nullable_type_declaration' => true,
        'trailing_comma_in_multiline' => ['elements' => ['arrays', 'match', 'parameters']],
    ])
    ->setRiskyAllowed(true)
    ->setFinder(
        (new PhpCsFixer\Finder())
            ->in(__DIR__.'/src')
            ->append([__FILE__])
            ->notPath('#/Fixtures/#')
            ->exclude([
                // explicit trigger_error tests
                'Symfony/Bridge/PhpUnit/Tests/DeprecationErrorHandler/',
                'Symfony/Component/Emoji/Resources/',
                'Symfony/Component/Intl/Resources/data/',
            ])
            // explicit tests for ommited @param type, against `no_superfluous_phpdoc_tags`
            ->notPath('Symfony/Component/PropertyInfo/Tests/Extractor/PhpDocExtractorTest.php')
            ->notPath('Symfony/Component/PropertyInfo/Tests/Extractor/PhpStanExtractorTest.php')
            // Support for older PHPunit version
            ->notPath('Symfony/Bridge/PhpUnit/SymfonyTestsListener.php')
            ->notPath('#Symfony/Bridge/PhpUnit/.*Mock\.php#')
            ->notPath('#Symfony/Bridge/PhpUnit/.*Legacy#')
            // explicit trigger_error tests
            ->notPath('Symfony/Component/ErrorHandler/Tests/DebugClassLoaderTest.php')
            // stop removing spaces on the end of the line in strings
            ->notPath('Symfony/Component/Messenger/Tests/Command/FailedMessagesShowCommandTest.php')
            // auto-generated proxies
            ->notPath('Symfony/Component/Cache/Traits/RelayProxy.php')
            ->notPath('Symfony/Component/Cache/Traits/Redis5Proxy.php')
            ->notPath('Symfony/Component/Cache/Traits/Redis6Proxy.php')
            ->notPath('Symfony/Component/Cache/Traits/RedisCluster5Proxy.php')
            ->notPath('Symfony/Component/Cache/Traits/RedisCluster6Proxy.php')
            // svg
            ->notPath('Symfony/Component/ErrorHandler/Resources/assets/images/symfony-ghost.svg.php')
            // HTML templates
            ->notPath('#Symfony/.*\.html\.php#')
    )
    ->setCacheFile('.php-cs-fixer.cache')
;
