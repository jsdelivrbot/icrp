<?php

/* themes/bootstrap/templates/filter/text-format-wrapper.html.twig */
class __TwigTemplate_48564107424bb36d3c36b8c76518925ab4b6cca4e57564a03ba65ea0c19a2c1f extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_b64f4a33e65fc9f0f15134b836fe904fbbbedef25d52a5a900f3035434010425 = $this->env->getExtension("native_profiler");
        $__internal_b64f4a33e65fc9f0f15134b836fe904fbbbedef25d52a5a900f3035434010425->enter($__internal_b64f4a33e65fc9f0f15134b836fe904fbbbedef25d52a5a900f3035434010425_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/filter/text-format-wrapper.html.twig"));

        $tags = array("if" => 18, "set" => 20);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if', 'set'),
                array(),
                array()
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setTemplateFile($this->getTemplateName());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 16
        echo "<div class=\"js-text-format-wrapper text-format-wrapper js-form-item form-item\">
  ";
        // line 17
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["children"]) ? $context["children"] : null), "html", null, true));
        echo "
  ";
        // line 18
        if ((isset($context["description"]) ? $context["description"] : null)) {
            // line 19
            echo "    ";
            // line 20
            $context["classes"] = array(0 => "help-block", 1 => ((            // line 22
(isset($context["aria_description"]) ? $context["aria_description"] : null)) ? ("description") : ("")));
            // line 25
            echo "    <div";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["description"]) ? $context["description"] : null), "html", null, true));
            echo "</div>
  ";
        }
        // line 27
        echo "</div>
";
        
        $__internal_b64f4a33e65fc9f0f15134b836fe904fbbbedef25d52a5a900f3035434010425->leave($__internal_b64f4a33e65fc9f0f15134b836fe904fbbbedef25d52a5a900f3035434010425_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/filter/text-format-wrapper.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  68 => 27,  60 => 25,  58 => 22,  57 => 20,  55 => 19,  53 => 18,  49 => 17,  46 => 16,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for a text format-enabled form element.*/
/*  **/
/*  * Available variables:*/
/*  * - children: Text format element children.*/
/*  * - description: Text format element description.*/
/*  * - attributes: HTML attributes for the containing element.*/
/*  * - aria_description: Flag for whether or not an ARIA description has been*/
/*  *   added to the description container.*/
/*  **/
/*  * @see template_preprocess_text_format_wrapper()*/
/*  *//* */
/* #}*/
/* <div class="js-text-format-wrapper text-format-wrapper js-form-item form-item">*/
/*   {{ children }}*/
/*   {% if description %}*/
/*     {%*/
/*       set classes = [*/
/*         'help-block',*/
/*         aria_description ? 'description',*/
/*       ]*/
/*     %}*/
/*     <div{{ attributes.addClass(classes) }}>{{ description }}</div>*/
/*   {% endif %}*/
/* </div>*/
/* */
