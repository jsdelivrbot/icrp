<?php

namespace Drupal\webform\Entity;

use Drupal\Core\Serialization\Yaml;
use Drupal\Core\Config\Entity\ConfigEntityBase;
use Drupal\Core\Entity\EntityStorageInterface;
use Drupal\webform\Utility\WebformOptionsHelper;
use Drupal\webform\WebformOptionsInterface;

/**
 * Defines the webform options entity.
 *
 * @ConfigEntityType(
 *   id = "webform_options",
 *   label = @Translation("Webform options"),
 *   handlers = {
 *     "access" = "Drupal\webform\WebformOptionsAccessControlHandler",
 *     "list_builder" = "Drupal\webform\WebformOptionsListBuilder",
 *     "form" = {
 *       "default" = "Drupal\webform\WebformOptionsForm",
 *       "delete" = "Drupal\Core\Entity\EntityDeleteForm",
 *     }
 *   },
 *   admin_permission = "administer webform",
 *   entity_keys = {
 *     "id" = "id",
 *     "label" = "label",
 *   },
 *   links = {
 *     "add-form" = "/admin/structure/webform/settings/options/add",
 *     "edit-form" = "/admin/structure/webform/settings/options/manage/{webform_options}/edit",
 *     "delete-form" = "/admin/structure/webform/settings/options/manage/{webform_options}/delete",
 *     "collection" = "/admin/structure/webform/settings/options/manage",
 *   },
 *   config_export = {
 *     "id",
 *     "uuid",
 *     "label",
 *     "options",
 *   }
 * )
 */
class WebformOptions extends ConfigEntityBase implements WebformOptionsInterface {

  /**
   * The webform options ID.
   *
   * @var string
   */
  protected $id;

  /**
   * The webform options UUID.
   *
   * @var string
   */
  protected $uuid;

  /**
   * The webform options label.
   *
   * @var string
   */
  protected $label;

  /**
   * The webform options options.
   *
   * @var string
   */
  protected $options;

  /**
   * The webform options decoded.
   *
   * @var string
   */
  protected $optionsDecoded;

  /**
   * {@inheritdoc}
   */
  public function getOptions() {
    if (!isset($this->optionsDecoded)) {
      try {
        $options = Yaml::decode($this->options);
        // Since YAML supports simple values.
        $options = (is_array($options)) ? $options : [];
      }
      catch (\Exception $exception) {
        $link = $this->link(t('Edit'), 'edit-form');
        \Drupal::logger('webform')->notice('%title options are not valid. @message', ['%title' => $this->label(), '@message' => $exception->getMessage(), 'link' => $link]);
        $options = FALSE;
      }
      $this->optionsDecoded = $options;
    }
    return $this->optionsDecoded;
  }

  /**
   * {@inheritdoc}
   */
  public function hasAlterHooks() {
    $hook_name = 'webform_options_' . $this->id() . '_alter';
    $alter_hooks = \Drupal::moduleHandler()->getImplementations($hook_name);
    return (count($alter_hooks)) ? TRUE : FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function preSave(EntityStorageInterface $storage) {
    parent::preSave($storage);

    // If the submitted options match the altered options clear the submission
    // options.
    $altered_options = [];
    $temp_element = [];
    \Drupal::moduleHandler()->alter('webform_options_' . $this->id(), $altered_options, $temp_element);
    $altered_options = WebformOptionsHelper::convertOptionsToString($altered_options);
    if ($altered_options == $this->getOptions()) {
      $this->options = '';
    }
  }

  /**
   * {@inheritdoc}
   */
  public function postSave(EntityStorageInterface $storage, $update = TRUE) {
    parent::postSave($storage, $update);

    // Clear cached properties.
    $this->optionsDecoded = NULL;
  }

  /**
   * {@inheritdoc}
   */
  public static function getElementOptions(array $element, $property_name = '#options') {
    // If element already has #options return them.
    if (is_array($element[$property_name])) {
      return $element[$property_name];
    }

    // Return empty options if element does not define an options id.
    if (empty($element[$property_name]) || !is_string($element[$property_name])) {
      return [];
    }

    // If options have been set return them.
    // This allows dynamic options to be overridden.
    $id = $element[$property_name];
    if ($webform_options = WebformOptions::load($id)) {
      $options = $webform_options->getOptions();
      if ($options) {
        return $options;
      }
    }

    // Get options using alter hook.
    $options = [];
    \Drupal::moduleHandler()->alter('webform_options_' . $id, $options, $element);

    // Log empty options.
    if (empty($options)) {
      \Drupal::logger('webform')->notice('Options %id do not exist.', ['%id' => $id]);
    }

    return $options;
  }

}