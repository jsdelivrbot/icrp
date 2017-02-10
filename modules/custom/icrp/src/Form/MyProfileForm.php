<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\MyProfileForm.
 */
namespace Drupal\icrp\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
//use Drupal\Core\Entity\EntityManagerInterface;
//use Drupal\Core\Password\PasswordInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Core\Password\PhpassHashedPassword;
use Drupal\Core\Password\PasswordInterface;


class MyProfileForm extends FormBase
{

    /**
     * The entity manager.
     *
     * @var \Drupal\Core\Entity\EntityManagerInterface
     */
    protected $entityManager;

    /**
     * The password hashing service.
     *
     * @var \Drupal\Core\Password\PasswordInterface
     */
    protected $passwordChecker;

    /**
     * Constructs a UserAuth object.
     *
     * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
     *   The entity manager.
     * @param \Drupal\Core\Password\PasswordInterface $password_checker
     *   The password service.
     */
    //public function __construct( PasswordInterface $password_checker) {
    public function __construct() {
        $uid = \Drupal::currentUser()->id();
        $this->entityManager = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        //$this->passwordChecker = $password_checker;
    }

    /**
     * {@inheritdoc}
     */

    public function getFormId()
    {
        return 'my_profile_form_old';
    }

    /**
     * {@inheritdoc}
     */
    public function buildForm(array $form, FormStateInterface $form_state)
    {
        $user = $this->entityManager;

        /* TODO: Search PEOPLE fields for field_subcommittee* then populate the array below */
        /* Get ICRP Subcommittees */
        $sub = array("field_subcommittee_annual_meetin");
        $sub_committees = array(
            "field_subcommittee_annual_meetin",
            "field_subcommittee_data_report",
            "field_subcommittee_evaluation",
            "field_subcommittee_external_comm",
            "field_subcommittee_internal_comm",
            "field_subcommittee_membership",
            "field_subcommittee_partner_opera",
            "field_subcommittee_web_site",
        );

        $form['#theme'] = "my_profile_form_old";

        $form['container'] = array(
            '#type' => 'container',
            '#attributes' => array(
                'class' => array('form--inline clearfix form-group'),
            )
        );

        $form['container']['name'] = array(
            '#type' => 'fieldset',
            '#title' => t('User Info'),
            '#prefix' => '<div class="col-sm-6">',
            '#suffix' => '</div>',
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['container']['name']['first_name'] = array(
            '#type' => 'textfield',
            '#title' => t('First Name'),
            '#default_value' => $user->get('field_first_name')->value,
            '#required' => TRUE,
            '#attributes' => array(
                'class' => array(''),
            )
        );
        $form['container']['name']['last_name'] = array(
            '#type' => 'textfield',
            '#title' => t('Last Name'),
            '#default_value' =>  $user->get('field_last_name')->value,
            '#required' => TRUE,
        );
        $form['container']['name']['email'] = array(
            '#type' => 'email',
            '#title' => t('Email'),
            '#default_value' => $user->getEmail(),
            '#required' => TRUE,
        );

        $form['container']['name']['password'] = array(
            '#type' => 'details',
            '#title' => t('Change Password'),
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['container']['name']['password']['current'] = array(
            '#type' => 'password',
            '#title' => t('Current Password'),
            '#default_value' =>"",
        );
        $markup = '<div class="description" style="padding-bottom:25px;">
        Required if you want to change the <em class="placeholder">Email address</em> or <em class="placeholder">Password</em> below. <a title="Send password reset instructions via email." href="/user/password">Reset your password</a>.
    </div>';
        $form['container']['name']['password']['markup_reset'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['container']['name']['password']['new'] = array(
            '#type' => 'password',
            '#title' => t('New Password'),
            '#default_value' => "",
        );
        $form['container']['name']['password']['confirm'] = array(
            '#type' => 'password',
            '#title' => t('Confirm New Password'),
            '#default_value' => "",
        );
        $markup = '<div class="description" id="edit-pass--description">To change the current user password, enter the new password in both fields.</div>';
        $form['container']['name']['password']['markup_password'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
        );

        $form['container']['committee'] = array(
            '#type' => 'fieldset',
            '#prefix' => '<div class="col-sm-6">',
            '#suffix' => '</div>',
            '#title' => 'ICRP Subcommittees',
        );

        $subcommittee = array(
            "Internal Communication",
            "External Communication",
            "Membership",
            "Annual Meeting",
            "Evaluation & Outcomes",
            "Web Site & Database",
            "Data Report & Data Quality",
            "Partner Operations"
        );
        /* COMMITTEE */
        foreach($sub_committees as $key => $field_subcommittee) {
            //drupal_set_message($key. " => ". $field_subcommittee);
            $form['container']['committee'][$field_subcommittee] = array(
                '#type' => 'checkbox',
                '#title' => t($user->get($field_subcommittee)->getFieldDefinition()->getLabel()),
                '#default_value' => (int)$user->get($field_subcommittee)->getValue(),
            );

        }

        $form['candidate_number'] = array(
            '#type' => 'tel',
            '#title' => t('Mobile no'),
        );

/*
        $form['action']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save'),
            '#button_type' => 'primary',
        );
*/
        $form['actions']['#type'] = 'actions';
        $form['actions']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save'),
            '#button_type' => 'primary',
        );
/*
        $form['actions']['#type'] = 'actions';
        $form['actions']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save 1'),
            '#button_type' => 'primary',
        );
*/

        drupal_set_message("Sending Form");
        //kint($form);
        //kint($form_state);
        return $form;
    }

    public function validateForm(array &$form, FormStateInterface $form_state)
    {
        $user = $this->entityManager;

        drupal_set_message("validateForm");
        foreach ($form_state->getValues() as $key => $value) {
            drupal_set_message($key . ': ' . $value);
        }
        /* Check to see if e-mail has changed.  If so then Password is required */
        drupal_set_message("New Email: ".$form_state->getValue('email'));
        drupal_set_message("Stored Email: ".$user->getEmail());
        drupal_set_message("Stored Password:".$user->getPassword());
        if($form_state->getValue('email') === $user->getEmail()) {
            drupal_set_message("Email MATCHES... Do nothing");
        } else {
            drupal_set_message("Email not match, check PASSWORD");
        }
        //$form_state->setErrorByName('candidate_number', $this->t('Mobile number is too short.'));
        //drupal_set_message("Sending Form 2");
        if (strlen($form_state->getValue('candidate_number')) < 10) {
            $form_state->setErrorByName('candidate_number', $this->t('Mobile number is too short.'));
        }
    }

    public function submitForm(array &$form, FormStateInterface $form_state)
    {
        drupal_set_message("submitForm");
        // drupal_set_message($this->t('@can_name ,Your application is being submitted!', array('@can_name' => $form_state->getValue('candidate_name'))));
        foreach ($form_state->getValues() as $key => $value) {
            drupal_set_message($key . ': ' . $value);
        }
    }

/*
    public function validateForm(array &$form, FormStateInterface $form_state)
    {
        kint($form_state);
        drupal_set_message("Hello");
        if (strlen($form_state->getValue('candidate_number')) < 10) {
            $form_state->setErrorByName('candidate_number', $this->t('Mobile number is too short.'));
        }
    }

    public function submitForm(array &$form, FormStateInterface $form_state)
    {
        kint($form_state);
        drupal_set_message("Hello");
        drupal_set_message($this->t(' ,Your application is being submitted!', array('@can_name' => $form_state->getValue('candidate_name'))));
        foreach ($form_state->getValues() as $key => $value) {
            drupal_set_message($key . ': ' . $value);
        }
    }
*/

}