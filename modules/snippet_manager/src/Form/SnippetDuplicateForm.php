<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Form\FormStateInterface;

/**
 * Form controller for the Snippet duplicate form.
 */
class SnippetDuplicateForm extends EntityForm {

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    parent::form($form, $form_state);

    $form['label'] = array(
      '#type' => 'textfield',
      '#title' => t('Snippet name'),
      '#required' => TRUE,
      '#size' => 32,
      '#maxlength' => 255,
      '#default_value' => t('Duplicate of @label', ['@label' => $this->entity->label()]),
    );

    $form['id'] = [
      '#type' => 'machine_name',
      '#maxlength' => 128,
      '#machine_name' => [
        'exists' => '\Drupal\snippet_manager\Entity\Snippet::load',
        'source' => ['label'],
      ],
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  protected function actions(array $form, FormStateInterface $form_state) {
    $actions['submit'] = [
      '#type' => 'submit',
      '#value' => t('Duplicate'),
    ];
    return $actions;
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $this->entity = $this->entity->createDuplicate();
    $this->entity->set('label', $form_state->getValue('label'));
    $this->entity->set('id', $form_state->getValue('id'));
    $this->entity->save();

    // Redirect the user to the snippet edit form.
    $form_state->setRedirectUrl($this->entity->toUrl('edit-form'));
  }

}
