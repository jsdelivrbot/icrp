<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests url variable plugin.
 *
 * @group snippet_manager
 */
class UrlVariableTest extends TestBase {

  /**
   * Tests url variable plugin.
   */
  public function testUrlVariable() {

    $path = 'node/1?page=1#title';

    $edit = [
      'plugin_id' => 'url',
      'name' => 'url',
    ];
    $this->drupalPostForm('snippet/alpha/edit/variable/add', $edit, 'Save and continue');

    $this->assertStatusMessage('The variable has been created.');

    $edit = [
      'path' => '/' . $path,
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    $this->assertStatusMessage('The variable has been updated.');

    $label = $this->xpath('//main//table/tbody/tr/td[position() = 1]/a[@href="#snippet-edit-form" and text() = "url"]');
    $this->assertTrue($label, 'Valid snippet variable label was found');

    $edit = [
      'code[value]' => '<div class="snippet-url">{{ url }}</div>',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    $url = base_path() . $path;
    $this->assertByXpath("//div[@class='snippet-url' and text()='$url']");

    // Test path validation.
    $edit = [
      'plugin_id' => 'url',
      'name' => 'wrong_url',
    ];
    $this->drupalPostForm('snippet/alpha/edit/variable/add', $edit, 'Save and continue');

    $edit = [
      'path' => $path,
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');
    $this->assertErrorMessage('The path should begin with "/".');

    // Make sure that empty path does not produce PHP exception.
    $this->drupalGet('snippet/alpha');
  }

  /**
   * Tests autocomplete path.
   */
  public function testAutocompletePath() {
    $suggestions = $this->drupalGetJSON('snippet-manager/path-autocomplete', ['query' => ['q' => '/user/pass']]);
    $this->assertEqual(count($suggestions), 1);
    $this->assertEqual($suggestions[0]['value'], '/user/password');
    $this->assertEqual($suggestions[0]['label'], '/user/password');
  }

}
